import SpriteKit

class Player: SKSpriteNode {
    var lastTimeShot: TimeInterval
    let cooldown = 0.5
    
    init(position: CGPoint, size: CGSize) {
        let texture = SKTexture(imageNamed: "bitty.png")
        texture.filteringMode = .nearest
        
        lastTimeShot = cooldown
        
        super.init(texture: texture, color: .white, size: size)
        
        self.position = position
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.friction = 10
        physicsBody?.linearDamping = 10
        physicsBody?.angularDamping = 10
        
        zRotation = CGFloat.pi/2
        
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
        
        if currentTime - lastTimeShot > cooldown {
            let projectile = Projectile(player: self, size: CGSize(width: 20, height: 10))
            scene?.addChild(projectile)
            
            lastTimeShot = currentTime
        }
        
    }
    
    func dash() {
        let dx = Double(cosf(Float(zRotation)))
        let dy = Double(sinf(Float(zRotation)))
        let amplitude = Double(150)
        physicsBody?.applyImpulse(CGVector(dx: dx*amplitude, dy: dy*amplitude))
    }
    
    func turnRight() {
        physicsBody?.angularVelocity = -15
    }
    
    func turnLeft() {
        physicsBody?.angularVelocity = 15
    }
}
