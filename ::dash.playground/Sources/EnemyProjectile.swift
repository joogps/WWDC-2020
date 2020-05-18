import SpriteKit

class EnemyProjectile: Projectile {
    init(enemy: Enemy) {
        super.init(node: enemy, size: CGSize(width: 15, height: 15), texture: SKTexture(imageNamed: "Assets/enemy-1.png"), velocity: 100, circleBody: true)
        
        physicsBody?.categoryBitMask = Categories.EnemyProjectile.rawValue
        physicsBody?.contactTestBitMask = Categories.Player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
