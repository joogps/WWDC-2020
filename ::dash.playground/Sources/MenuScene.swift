import SpriteKit
import AVFoundation

public class MenuScene: SKScene {
    var title: SKLabelNode!
    var subTitle: SKLabelNode!
    
    var startSoundEffect: AVAudioPlayer!
    
    var canMove = false
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        title = SKLabelNode()
        title.text = "//dash"
        title.fontSize = 85
        title.fontColor = .black
        title.position = CGPoint(x: frame.midX, y: frame.midY-title.frame.height/2)
        
        subTitle = SKLabelNode()
        subTitle.text = "click anywhere to start"
        subTitle.fontSize = 32
        subTitle.fontColor = .black
        subTitle.position = CGPoint(x: frame.midX, y: 50)
        subTitle.alpha = 0
        
        startSoundEffect = loadSound(fileNamed: "Sounds/confirmation_001.mp3")
        
        var fonts = helveticaNeueFonts().shuffled()
        fonts.append("HelveticaNeue-BoldItalic")
        animateLabelFont(label: title, fonts: fonts, timeInterval: 0.1, callback: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1.5)
                self.subTitle.run(fadeIn)
            }
        })
        
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
        startSoundEffect?.play()
        
        let transition = SKTransition.reveal(with: .up, duration: 0.75)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition: transition)
    }
}
