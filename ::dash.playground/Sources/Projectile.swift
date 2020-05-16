import SpriteKit

class Projectile: SKSpriteNode {
    init(player: Player, size: CGSize) {
        super.init(texture: SKTexture(), color: .white, size: size)
        
        let dx = CGFloat(cosf(Float(player.zRotation)))
        let dy = CGFloat(sinf(Float(player.zRotation)))
        
        let px = player.position.x
        let py = player.position.y
        
        let pw = player.size.width
        let ph = player.size.height
        
        self.position = CGPoint(x: px+(dx*pw/2), y: py+(dy*ph/2))
        zRotation = player.zRotation
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        physicsBody?.velocity = CGVector(dx: dx*250, dy: dy*250)
        
        physicsBody?.categoryBitMask = Categories.Projectile.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Categories.Enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
