import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: Player!
    private var enemies = [Enemy]()
    
    var scoreLabel: SKLabelNode!
    var score = 0

    var currentTime: TimeInterval!
    
    var enemyTimer: Timer!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .black
        
        player = Player(position: CGPoint(x: view.frame.width/2, y: view.frame.height/2), size: CGSize(width: 100, height: 100))
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 85
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-scoreLabel.frame.height/2)
        scoreLabel.zPosition = -1
        
        startEnemies()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        addChild(player)
        addChild(scoreLabel)
    }
    
    func startEnemies() {
        enemyTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        let enemy = Enemy(frame: view!.frame, size: CGSize(width: 50, height: 50))
        enemies.append(enemy)
        addChild(enemy)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        
        for enemy in enemies {
            enemy.follow(point: player.position)
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodiesBitMasks: [UInt32] = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        let projectileEnemyBitMasks: [UInt32] = [Categories.Projectile.rawValue, Categories.Enemy.rawValue]
        let enemyPlayerBitMasks: [UInt32] = [Categories.Player.rawValue, Categories.Enemy.rawValue]
        
        switch bodiesBitMasks {
        case projectileEnemyBitMasks:
            let emitter = SKEmitterNode(fileNamed: "explosion")
            
            let p1 = contact.bodyB.node!.position
            let p2 = (contact.bodyB.node as! Enemy).originalPosition
            
            emitter!.position = CGPoint(x: p1.x+p2.x, y: p1.y+p2.y)
            addChild(emitter!)
            
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
            if let index = enemies.firstIndex(of: contact.bodyB.node! as! Enemy) {
                enemies.remove(at: index)
            }
            
            score += 1
            scoreLabel.text = String(score)
            
            if score % 10 == 0 {
                let fonts = Array(helveticaNeueFonts().shuffled()[0...3])
                animateLabelFont(label: scoreLabel, fonts: fonts, timeInterval: 0.1)
            }
        case enemyPlayerBitMasks:
            enemyTimer.invalidate()
            let transition = SKTransition.moveIn(with: .down, duration: 0.5)
            let scene = EndingScene(size: size, score: score)
            self.view?.presentScene(scene, transition: transition)
        default:
            return
        }
    }
    
    override public func mouseMoved(with event: NSEvent) {
        let point = event.location(in: self)
        
        let relativeToStart = CGPoint(x: point.x - player.position.x, y: point.y - player.position.y)
        let radians = atan2(relativeToStart.y, relativeToStart.x)
        player.zRotation = radians
    }
    
    public override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        switch keyCode {
        case 49:
            player.shoot()
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
}
