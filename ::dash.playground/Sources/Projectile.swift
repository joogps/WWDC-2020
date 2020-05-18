import SpriteKit

class Projectile: SKSpriteNode {
    init(node: SKSpriteNode, size: CGSize, texture: SKTexture = SKTexture(), velocity: CGFloat, circleBody: Bool = false) {
        super.init(texture: texture, color: .white, size: size)
        
        let dx = CGFloat(cosf(Float(node.zRotation)))
        let dy = CGFloat(sinf(Float(node.zRotation)))
        
        let px = node.position.x
        let py = node.position.y
        
        let pw = node.size.width
        let ph = node.size.height
        
        position = CGPoint(x: px+(dx*(pw/2-size.width/2)), y: py+(dy*(ph/2-size.height/2)))
        zRotation = node.zRotation
        
        zPosition = -1
        
        speed = node.speed
        
        physicsBody = circleBody ? SKPhysicsBody(circleOfRadius: size.width/2) : SKPhysicsBody(rectangleOf: size)
        
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        let amplitude = velocity*speed
        physicsBody?.velocity = CGVector(dx: dx*amplitude, dy: dy*amplitude)
        
        physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
