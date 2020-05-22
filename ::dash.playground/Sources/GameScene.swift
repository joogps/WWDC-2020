import SpriteKit
import AVFoundation

public class GameScene: SKScene, SKPhysicsContactDelegate {
    var background: SKSpriteNode!
    var player: Player!
    var enemies = [Enemy]()
    
    var difficultyIncreaseSound: AVAudioPlayer!
    var explosionSound: AVAudioPlayer!
    var breakingSound: AVAudioPlayer!
    
    var strengthStart: AVAudioPlayer!
    var strengthEnd: AVAudioPlayer!
    
    var slowMotionStart: AVAudioPlayer!
    var slowMotionTimerTick: AVAudioPlayer!
    var slowMotionTimerDone: AVAudioPlayer!
    
    var difficulty = 1
    
    var scoreLabel: SKLabelNode!
    var score = 0

    var currentTime: TimeInterval!
    
    var enemyTimer: Timer!
    
    var slowMotionTimer: Timer!
    var slowMotionStresses = 5
    
    var powerUpActive = false
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        background = SKSpriteNode(color: .black, size: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -2
        
        player = Player(position: CGPoint(x: view.frame.midX, y: view.frame.midY))
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 85
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-scoreLabel.frame.height/2)
        scoreLabel.zPosition = -1
        
        startEnemyTimer()
        
        difficultyIncreaseSound = loadSound(fileNamed: "Sounds/confirmation_003.mp3")
        explosionSound = loadSound(fileNamed: "Sounds/error_004.mp3")
        breakingSound = loadSound(fileNamed: "Sounds/click_005.mp3")
        
        slowMotionStart = loadSound(fileNamed: "Sounds/minimize_008.mp3")
        slowMotionTimerTick = loadSound(fileNamed: "Sounds/tick_002.mp3")
        slowMotionTimerDone = loadSound(fileNamed: "Sounds/glass_004.mp3")
        
        strengthStart = loadSound(fileNamed: "Sounds/toggle_001.mp3")
        strengthEnd = loadSound(fileNamed: "Sounds/error_003.mp3")
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(player)
        addChild(scoreLabel)
    }
    
    func startEnemyTimer() {
        enemyTimer?.invalidate()
        let speed = 1/(Double(min(difficulty, 5)) / 5.0)/Double(physicsWorld.speed)
        enemyTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        let strength = Bool.random() ? 1 : min(difficulty, Int.random(in: 2...3))
        let smart = difficulty > 3 ? (Float.random(in: 0...1) > 0.9) : false
        let enemy = Enemy(frame: view!.frame, strength: strength, smart: smart)
        enemies.append(enemy)
        addChild(enemy)
    }
    
    func createPowerUp(type: Int) {
        let texture = type == 0 ? "strength-power-up" : "slow-motion-power-up"
        let category = (type == 0 ? Categories.StrengthPowerUp : Categories.SlowMotionPowerUp).rawValue
        let powerup = PowerUp(frame: view!.frame, texture: "Assets/\(texture)", category: category)
        addChild(powerup)
    }
    
    func stressBackground() {
        background.alpha = 0
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.75)
        background.run(fadeIn)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        
        for enemy in enemies {
            enemy.follow(point: player.position)
        }
        
        if !powerUpActive && difficulty > 3 && Float.random(in: 0...1) > 0.9995-Float(enemies.count)/1000.0 {
            let type = Int.random(in: 0...1)
            createPowerUp(type: type)
            powerUpActive = true
        }
    }
    
    func createExplosion(node: SKNode) -> SKEmitterNode {
        let emitter = SKEmitterNode(fileNamed: "Assets/explosion")
        emitter!.position = node.position
        addChild(emitter!)
        return emitter!
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodiesBitMasks: [UInt32] = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        let projectileEnemyBitMasks: [UInt32] = [Categories.Projectile.rawValue, Categories.Enemy.rawValue]
        let playerEnemyBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.Enemy.rawValue]
        let playerEnemyProjectileBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.EnemyProjectile.rawValue]
        let playerStrengthPowerUpBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.StrengthPowerUp.rawValue]
        let playerSlowMotionPowerUpBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.SlowMotionPowerUp.rawValue]
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        switch bodiesBitMasks {
        case projectileEnemyBitMasks:
            hapticFeedback()
            
            let projectile = nodeA as! PlayerProjectile
            let enemy = nodeB as! Enemy
            
            if !projectile.superShot {
                projectile.removeFromParent()
            }
            
            let emitter = createExplosion(node: nodeB)
            
            if enemy.strength > 1 && !projectile.superShot {
                if physicsWorld.speed == 1 {
                    breakingSound?.play()
                }
                
                enemy.removeStrength()
                emitter.particleScale = 0.1
                return
            }
            
            if physicsWorld.speed == 1 {
                explosionSound?.play()
            }
            
            enemy.removeFromParent()
            if let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
            }
            
            score += 1
            scoreLabel.text = String(score)
            
            if score % 15 == 0 {
                difficultyIncreaseSound?.play()
                
                let fonts = Array(helveticaNeueFonts().shuffled()[0...3])
                animateLabelFont(label: scoreLabel, fonts: fonts, timeInterval: 0.1)
                difficulty += 1
                
                startEnemyTimer()
            }
        case playerEnemyBitMasks, playerEnemyProjectileBitMasks:
            if player.stronger {
                strengthEnd?.play()
                
                nodeB.removeFromParent()
                player.disableStronger()
                powerUpActive = false
                return
            }
            
            hapticFeedback()
            
            enemyTimer?.invalidate()
            slowMotionTimer?.invalidate()
            
            for enemy in enemies {
                if enemy.smart {
                    enemy.projectileTimer.invalidate()
                }
            }
            
            let transition = SKTransition.moveIn(with: .down, duration: 0.75)
            let scene = EndingScene(size: size, score: score)
            self.view?.presentScene(scene, transition: transition)
        case playerStrengthPowerUpBitMasks:
            strengthStart?.play()
            
            hapticFeedback()
            
            nodeB.removeFromParent()
            
            player.enableStronger()
        case playerSlowMotionPowerUpBitMasks:
            slowMotionStart?.play()
            
            nodeB.removeFromParent()
            
            physicsWorld.speed = 0.5
            player.speed = 2
            
            startSlowMotionTimer()
            
            startEnemyTimer()
        default:
            return
        }
    }
    
    func startSlowMotionTimer() {
        slowMotionStresses = 5
        slowMotionTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            
            if self.slowMotionStresses <= 1 {
                self.slowMotionTimerDone?.play()
                
                timer.invalidate()
                
                self.powerUpActive = false
                
                self.physicsWorld.speed = 1
                self.player.speed = 1
                
                return
            }
            
            self.slowMotionTimerTick?.play()
            self.stressBackground()
            self.slowMotionStresses -= 1
        }
    }
    
    override public func mouseMoved(with event: NSEvent) {
        player.rotateToPoint(point: event.location(in: self))
    }
    
    override public func mouseDragged(with event: NSEvent) {
        player.rotateToPoint(point: event.location(in: self))
    }
    
    public override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 49, 36:
            player.prepareToShoot()
        case 13, 126:
            player.dash()
        case 0, 123:
            player.turnLeft()
        case 2, 124:
            player.turnRight()
        default:
            return
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        if event.keyCode == 49 || event.keyCode == 36 {
            player.shoot()
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        player.regularShoot()
    }
    
    public override func pressureChange(with event: NSEvent) {
        if event.pressure >= 1 {
            player.superShoot()
        }
    }
}
