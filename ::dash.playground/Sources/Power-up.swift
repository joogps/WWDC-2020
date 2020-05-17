import SpriteKit

class PowerUp: SKSpriteNode {
    init(frame: CGRect, size: CGSize, texture: String, category: UInt32) {
        super.init(texture: SKTexture(imageNamed: texture), color: .white, size: size)
        
        let side = Int.random(in: 0...1)
        position = CGPoint(x: side == 0 ? -size.width/2 : frame.width+size.width/2, y: CGFloat.random(in: 0...frame.height))
        
        zPosition = 1
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        physicsBody?.categoryBitMask = category
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Categories.Player.rawValue
        
        let path = CGMutablePath()
        path.move(to: position)
        
        let detail = Int.random(in: 2...8)
        let jump = frame.width/CGFloat(detail)
        
        for i in 1...detail {
            let x = side == 0 ? CGFloat(i)*jump : frame.width-CGFloat(i)*jump
            let y = i % 2 == 0 ? -size.height*2 : frame.height+size.height*2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        let move = SKAction.follow(path, asOffset: false, orientToPath: false, speed: 150)
        run(move, completion: {
            (self.scene as! GameScene).powerUpActive = false
            self.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
