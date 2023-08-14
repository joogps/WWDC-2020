import SpriteKit

class PlayerProjectile: Projectile {
    let superShot: Bool
    
    init(player: Player, size: CGSize = CGSize(width: 20, height: 10), superShot: Bool = false) {
        self.superShot = superShot
        
        super.init(node: player, size: size, velocity: 275)
        
        physicsBody?.categoryBitMask = Categories.PlayerProjectile.rawValue
        physicsBody?.contactTestBitMask = Categories.Enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
