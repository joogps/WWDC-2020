import SpriteKit

public class InitialView: SKView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let options = [.mouseMoved, .activeInKeyWindow, .activeAlways, .inVisibleRect] as NSTrackingArea.Options
        let tracker = NSTrackingArea(rect: frame, options: options, owner: self, userInfo: nil)
        
        addTrackingArea(tracker)
        
        let menuScene = MenuScene(size: frame.size)
        presentScene(menuScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
