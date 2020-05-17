import SpriteKit

class EnemyProjectile: SKSpriteNode {
    init(enemy: Enemy, size: CGSize) {
        super.init(texture: SKTexture(imageNamed: "enemy-1.png"), color: .white, size: size)
        
        let dx = CGFloat(cosf(Float(enemy.zRotation)))
        let dy = CGFloat(sinf(Float(enemy.zRotation)))
        
        let px = enemy.position.x
        let py = enemy.position.y
        
        let pw = enemy.size.width
        let ph = enemy.size.height
        
        self.position = CGPoint(x: px+(dx*(pw/2-size.width/2)), y: py+(dy*(ph/2-size.height/2)))
        zRotation = enemy.zRotation
        
        zPosition = -1
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        physicsBody?.velocity = CGVector(dx: dx*150, dy: dy*150)
        
        physicsBody?.categoryBitMask = Categories.EnemyProjectile.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Categories.Player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
