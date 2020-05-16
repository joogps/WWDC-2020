import SpriteKit

class Enemy: SKShapeNode {
    let parentFrame: CGRect
    var originalPosition = CGPoint(x: 0, y: 0)
    
    init(frame: CGRect, size: CGSize) {
        self.parentFrame = frame
        
        super.init()
        
        var position: CGPoint
        
        switch Int.random(in: 0...3) {
        case 0:
            position = CGPoint(x: parentFrame.width, y: CGFloat.random(in: 0...parentFrame.height))
        case 1:
            position = CGPoint(x: CGFloat.random(in: 0...parentFrame.width), y: -size.height)
        case 2:
            position = CGPoint(x: -size.width, y: CGFloat.random(in: 0...parentFrame.height))
        case 3:
            position = CGPoint(x: CGFloat.random(in: 0...parentFrame.width), y: parentFrame.height)
        default:
            return
        }
        
        originalPosition = position
        
        path = CGPath(ellipseIn: CGRect(x: position.x, y: position.y, width: size.width, height: size.height), transform: .none)
        fillColor = .white
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2, center: CGPoint(x: position.x+size.width/2, y: position.y+size.height/2))
        
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        
        physicsBody?.categoryBitMask = Categories.Enemy.rawValue
        physicsBody?.collisionBitMask = Categories.Enemy.rawValue
        physicsBody?.contactTestBitMask = Categories.Projectile.rawValue | Categories.Player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func follow(point: CGPoint) {
        let x = position.x + originalPosition.x
        let y = position.y + originalPosition.y
        
        let relativeToStart = CGPoint(x: point.x-x, y: point.y-y)
        let radians = atan2(relativeToStart.y, relativeToStart.x)
        
        let dx = Double(cosf(Float(radians)))
        let dy = Double(sinf(Float(radians)))
        
        physicsBody?.velocity = CGVector(dx: dx*75, dy: dy*75)
    }
}
