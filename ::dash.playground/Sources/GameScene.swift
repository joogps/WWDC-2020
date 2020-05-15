import SpriteKit

public class GameScene: SKScene {
    private var player : Player!
    var currentTime: TimeInterval!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .black
        
        player = Player(position: CGPoint(x: view.frame.width/2, y: view.frame.height/2), size: CGSize(width: 100, height: 100))
        addChild(player)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    override public func mouseMoved(with event: NSEvent) {
        let point = event.location(in: self)
        
        let relativeToStart = CGPoint(x: point.x - player.position.x, y: point.y - player.position.y)
        let radians = atan2(relativeToStart.y, relativeToStart.x)
        player.zRotation = radians
    }
    
    public override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    public override func keyDown(with event: NSEvent) {
        let keyCode = event.keyCode
        switch keyCode {
        case 49:
            player.shoot()
        case 13, 126, 36:
            player.dash()
        case 0, 123:
            player.turnLeft()
        case 2, 124:
            player.turnRight()
        default:
            return
        }
    }
}
