import SpriteKit
import AVFoundation

class Player: SKSpriteNode {
    var lastTimeShot: TimeInterval
    let cooldown = 0.3
    
    var lastTimeSuperShot: TimeInterval
    let superCooldown = 10.0
    
    var superShotInterval: TimeInterval
    var superShotMinInterval = 1.0
    
    var stronger = false
    
    init(position: CGPoint, size: CGSize = CGSize(width: 100, height: 100)) {
        lastTimeShot = cooldown
        lastTimeSuperShot = superCooldown
        superShotInterval = 0.0
        
        let texture = SKTexture(imageNamed: "Assets/bitty-1.png")
        super.init(texture: texture, color: .white, size: size)
        
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.linearDamping = 15
        physicsBody?.angularDamping = 10
        
        zRotation = CGFloat.pi/2
        
        physicsBody?.categoryBitMask = Categories.Player.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Categories.Enemy.rawValue
        
        blink()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blink() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3..<7)) {
            self.setTexture(blinking: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1..<0.2)) {
                self.setTexture()
                self.blink()
            }
        }
    }
    
    func shoot() {
        let currentTime = (scene as! GameScene).currentTime!
        
        if currentTime - superShotInterval > superShotMinInterval {
            superShoot()
        } else {
            regularShoot()
        }
    }
    
    func regularShoot() {
        let gameScene = scene as! GameScene
        
        if gameScene.currentTime - lastTimeShot > cooldown {
            gameScene.initialView.shootSound?.stop()
            gameScene.initialView.shootSound?.play()
            
            let projectile = PlayerProjectile(player: self)
            gameScene.addChild(projectile)
            
            lastTimeShot = gameScene.currentTime
        }
    }
    
    func superShoot() {
        let gameScene = scene as! GameScene
        
        if gameScene.currentTime - lastTimeSuperShot > superCooldown {
            gameScene.initialView.superShootSound?.play()
            
            let projectile = PlayerProjectile(player: self, size: CGSize(width: 60, height: 30), superShot: true)
            gameScene.addChild(projectile)
            
            lastTimeSuperShot = gameScene.currentTime
        } else if gameScene.currentTime - lastTimeSuperShot > 0.5 {
            gameScene.initialView.errorSound?.play()
        }
        
        gameScene.stressBackground()
    }
    
    func dash() {
        let dx = Double(cosf(Float(zRotation)))
        let dy = Double(sinf(Float(zRotation)))
        let amplitude = Double(250.0*speed)
        physicsBody?.applyImpulse(CGVector(dx: dx*amplitude, dy: dy*amplitude))
    }
    
    func turnRight() {
        physicsBody?.angularVelocity = -7.5*speed
    }
    
    func turnLeft() {
        physicsBody?.angularVelocity = 7.5*speed
    }
    
    func rotateToPoint(point: CGPoint) {
        let relativeToStart = CGPoint(x: point.x - position.x, y: point.y - position.y)
        let radians = atan2(relativeToStart.y, relativeToStart.x)
        zRotation = radians
    }
    
    func prepareToShoot() {
        superShotInterval = (scene as! GameScene).currentTime!
    }
    
    func enableStronger() {
        stronger = true
        setTexture()
    }
    
    func disableStronger() {
        stronger = false
        setTexture()
    }
    
    func setTexture(blinking: Bool = false) {
        let prefix = stronger ? "stronger-" : ""
        let suffix = blinking ? "-2" : "-1"
        self.texture = SKTexture(imageNamed: "Assets/\(prefix)bitty\(suffix).png")
    }
}
