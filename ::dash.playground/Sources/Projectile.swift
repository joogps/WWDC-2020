import SpriteKit

class Projectile: SKSpriteNode {
    let superShot: Bool
    
    init(player: Player, size: CGSize, superShot: Bool = false) {
        self.superShot = superShot
        
        super.init(texture: SKTexture(), color: .white, size: size)
        
        let dx = CGFloat(cosf(Float(player.zRotation)))
        let dy = CGFloat(sinf(Float(player.zRotation)))
        
        let px = player.position.x
        let py = player.position.y
        
        let pw = player.size.width
        let ph = player.size.height
        
        self.position = CGPoint(x: px+(dx*(pw/2-size.width/2)), y: py+(dy*(ph/2-size.height/2)))
        zRotation = player.zRotation
        
        zPosition = -1
        
        speed = player.speed
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        let amplitude = 275*speed
        physicsBody?.velocity = CGVector(dx: dx*amplitude, dy: dy*amplitude)
        
        physicsBody?.categoryBitMask = Categories.Projectile.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = Categories.Enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
