import SpriteKit

class Enemy: SKSpriteNode {
    let parentFrame: CGRect
    
    var strength: Int
    var shooter: Bool
    
    var projectileTimer: Timer!
    
    init(frame: CGRect, size: CGSize, strength: Int = 0, shooter: Bool = false) {
        parentFrame = frame
        
        self.strength = strength
        self.shooter = shooter
        
        let prefix = shooter ? "shooter-" : ""
        let texture = SKTexture(imageNamed: "Assets/\(prefix)enemy-\(strength).png")
        super.init(texture: texture, color: .white, size: size)
        
        switch Int.random(in: 0...3) {
        case 0:
            position = CGPoint(x: parentFrame.width+size.width/2, y: CGFloat.random(in: 0...parentFrame.height))
        case 1:
            position = CGPoint(x: CGFloat.random(in: 0...parentFrame.width), y: -size.height/2)
        case 2:
            position = CGPoint(x: -size.width/2, y: CGFloat.random(in: 0...parentFrame.height))
        case 3:
            position = CGPoint(x: CGFloat.random(in: 0...parentFrame.width), y: parentFrame.height+size.width/2)
        default:
            return
        }
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        physicsBody?.categoryBitMask = Categories.Enemy.rawValue
        physicsBody?.collisionBitMask = Categories.Enemy.rawValue
        physicsBody?.contactTestBitMask = Categories.Projectile.rawValue | Categories.Player.rawValue
        
        if shooter {
            blink()
            startProjectileTimer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func follow(point: CGPoint) {
        let x = position.x
        let y = position.y
        
        let relativeToStart = CGPoint(x: point.x-x, y: point.y-y)
        zRotation = atan2(relativeToStart.y, relativeToStart.x)
        
        let dx = Double(cosf(Float(zRotation)))
        let dy = Double(sinf(Float(zRotation)))
        
        physicsBody?.velocity = CGVector(dx: dx*75, dy: dy*75)
    }
    
    func removeStrength() {
        strength -= 1
        setTexture()
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
    
    func startProjectileTimer() {
        projectileTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
    }
    
    @objc func shoot() {
        let projectile = EnemyProjectile(enemy: self, size: CGSize(width: 15, height: 15))
        scene?.addChild(projectile)
    }
    
    func setTexture(blinking: Bool = false) {
        let prefix = blinking ? "" : (shooter ? "shooter-" : "")
        texture = SKTexture(imageNamed: "Assets/\(prefix)enemy-\(strength).png")
    }
}
