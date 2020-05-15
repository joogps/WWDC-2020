import SpriteKit

public class MenuScene: SKScene {
    var title: SKLabelNode!
    var subTitle: SKLabelNode!
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        title = SKLabelNode()
        title.text = "//dash"
        title.fontSize = 85
        title.fontColor = .black
        title.position = CGPoint(x: frame.midX, y: frame.midY-20)
        
        subTitle = SKLabelNode()
        subTitle.text = "click anywhere to start"
        subTitle.fontSize = 32
        subTitle.fontColor = .black
        subTitle.position = CGPoint(x: frame.midX, y: 50)
        subTitle.alpha = 0
        
        var fonts = helveticaNeueFonts().shuffled()
        fonts.append("HelveticaNeue-BoldItalic")
        animateLabelFont(label: self.title, fonts: fonts, timeInterval: 0.1, callback: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1.5)
                self.subTitle.run(fadeIn)
            }
        })
        
        
        // let feedbackPerformer = NSHapticFeedbackManager.defaultPerformer
        // feedbackPerformer.perform(.levelChange, performanceTime: .now)
        
        addChild(title)
        addChild(subTitle)
    }
    
    public override func keyDown(with event: NSEvent) {
        openGameScene()
    }
    
    public override func mouseDown(with event: NSEvent) {
        openGameScene()
    }
    
    func openGameScene() {
        let transition = SKTransition.reveal(with: .up, duration: 0.5)
        let scene:SKScene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
}
