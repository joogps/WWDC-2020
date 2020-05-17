import SpriteKit

class Player: SKSpriteNode {
    var lastTimeShot: TimeInterval
    let cooldown = 0.5
    
    var lastTimeSuperShot: TimeInterval
    let superCooldown = 10.0
    
    var superShotInterval: TimeInterval
    var superShotMinInterval = 1.0
    
    init(position: CGPoint, size: CGSize) {
        lastTimeShot = cooldown
        lastTimeSuperShot = superCooldown
        superShotInterval = 0.0
        
        let texture = SKTexture(imageNamed: "bitty.png")
        super.init(texture: texture, color: .white, size: size)
        
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.friction = 10
        physicsBody?.linearDamping = 10
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
            self.texture = SKTexture()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.1..<0.2)) {
                self.texture = SKTexture(imageNamed: "bitty.png")
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
        let currentTime = (scene as! GameScene).currentTime!
        
        if currentTime - lastTimeShot > cooldown {
            let projectile = Projectile(player: self, size: CGSize(width: 20, height: 10))
            scene?.addChild(projectile)
            
            lastTimeShot = currentTime
        }
    }
    
    func superShoot() {
        let currentTime = (scene as! GameScene).currentTime!
        
        if currentTime - lastTimeSuperShot > superCooldown {
            let projectile = Projectile(player: self, size: CGSize(width: 60, height: 30), superShot: true)
            scene?.addChild(projectile)
            
            lastTimeSuperShot = currentTime
            
            (scene as! GameScene).stressBackground()
        }
    }
    
    func dash() {
        let dx = Double(cosf(Float(zRotation)))
        let dy = Double(sinf(Float(zRotation)))
        let amplitude = Double(175)
        physicsBody?.applyImpulse(CGVector(dx: dx*amplitude, dy: dy*amplitude))
    }
    
    func turnRight() {
        physicsBody?.angularVelocity = -7.5
    }
    
    func turnLeft() {
        physicsBody?.angularVelocity = 7.5
    }
    
    func rotateToPoint(point: CGPoint) {
        let relativeToStart = CGPoint(x: point.x - position.x, y: point.y - position.y)
        let radians = atan2(relativeToStart.y, relativeToStart.x)
        zRotation = radians
    }
    
    func prepareToShoot() {
        superShotInterval = (scene as! GameScene).currentTime!
    }
}
