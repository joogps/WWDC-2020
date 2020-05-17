import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    private var background: SKSpriteNode!
    private var player: Player!
    private var enemies = [Enemy]()
    
    var difficulty = 1
    
    var scoreLabel: SKLabelNode!
    var score = 0

    var currentTime: TimeInterval!
    
    var enemyTimer: Timer!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        background = SKSpriteNode(color: .black, size: frame.size)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -2
        
        player = Player(position: CGPoint(x: view.frame.width/2, y: view.frame.height/2), size: CGSize(width: 100, height: 100))
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 85
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-scoreLabel.frame.height/2)
        scoreLabel.zPosition = -1
        
        startEnemyTimer()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(background)
        addChild(player)
        addChild(scoreLabel)
    }
    
    func startEnemyTimer() {
        enemyTimer = Timer.scheduledTimer(timeInterval: 1/(Double(min(difficulty, 5)) / 5.0), target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        let strength = Int.random(in: 1...min(difficulty, 3))
        let shooter = difficulty > 3 ? Bool.random() : false
        let enemy = Enemy(frame: view!.frame, size: CGSize(width: 50, height: 50), strength: strength, shooter: shooter)
        enemies.append(enemy)
        addChild(enemy)
    }
    
    func stressBackground() {
        background.alpha = 0
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        background.run(fadeIn)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        
        for enemy in enemies {
            enemy.follow(point: player.position)
        }
    }
    
    func createExplosion(node: SKNode) -> SKEmitterNode {
        let emitter = SKEmitterNode(fileNamed: "explosion")
        emitter!.position = node.position
        addChild(emitter!)
        return emitter!
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodiesBitMasks: [UInt32] = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        let projectileEnemyBitMasks: [UInt32] = [Categories.Projectile.rawValue, Categories.Enemy.rawValue]
        let enemyPlayerBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.Enemy.rawValue]
        let playerEnemyProjectileBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.EnemyProjectile.rawValue]
        
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        switch bodiesBitMasks {
        case projectileEnemyBitMasks:
            hapticFeedback()
            
            let projectile = nodeA as! Projectile
            let enemy = nodeB as! Enemy
            
            if !projectile.superShot {
                projectile.removeFromParent()
            }
            
            let emitter = createExplosion(node: nodeB)
            
            if enemy.strength > 1 && !projectile.superShot {
                enemy.removeStrength()
                emitter.particleScale = 0.1
                return
            }
            
            nodeB.removeFromParent()
            if let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
            }
            
            score += 1
            scoreLabel.text = String(score)
            
            if score % 10 == 0 {
                let fonts = Array(helveticaNeueFonts().shuffled()[0...3])
                animateLabelFont(label: scoreLabel, fonts: fonts, timeInterval: 0.1, withFeedback: true)
                difficulty += 1
                
                enemyTimer.invalidate()
                startEnemyTimer()
            }
        case enemyPlayerBitMasks, playerEnemyProjectileBitMasks:
            hapticFeedback()
            
            enemyTimer.invalidate()
            
            let transition = SKTransition.moveIn(with: .down, duration: 0.5)
            let scene = EndingScene(size: size, score: score)
            self.view?.presentScene(scene, transition: transition)
        default:
            return
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
        case 49:
            player.prepareToShoot()
        case 13, 126, 36:
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
        if event.keyCode == 49 {
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
