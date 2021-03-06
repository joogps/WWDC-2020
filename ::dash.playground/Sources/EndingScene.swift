import SpriteKit
import AVFoundation

let goodPhrases = ["you rocked it", "you're awesome", "impressive!", "good game", "pew pew"]
let badPhrases = ["you can do better", "i believe in u", "try harder next time", "don't give up", "give it another shot"]

public class EndingScene: SKScene {
    var title: SKLabelNode!
    var subTitle: SKLabelNode!
    
    var score: Int!
    
    var canMove = false
    
    var initialView: InitialView!
    
    public init(size: CGSize, score: Int) {
        self.score = score
        
        super.init(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        initialView = view as? InitialView
        
        if score >= 20 {
            initialView.goodSound?.play()
        } else {
            initialView.badSound?.play()
        }
        
        backgroundColor = .white
        
        title = SKLabelNode()
        title.text = (score >= 20 ? goodPhrases : badPhrases).randomElement()!
        title.fontSize = 65
        title.fontColor = .black
        title.position = CGPoint(x: 80, y: frame.midY-title.frame.height/2+65)
        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        subTitle = SKLabelNode()
        subTitle.text = "your score: \(score ?? 0)"
        subTitle.fontSize = 32
        subTitle.fontColor = .black
        subTitle.position = CGPoint(x: 80, y: frame.midY-subTitle.frame.height/2)
        subTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        subTitle.alpha = 0
        
        var fonts = Array(helveticaNeueFonts().shuffled()[0...6])
        fonts.append("HelveticaNeue-BoldItalic")
        animateLabelFont(label: title, fonts: fonts, timeInterval: 0.1, callback: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
                self.subTitle.run(fadeIn, completion: {
                    self.canMove = true
                })
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
        if !canMove { return }
        
        initialView.startSoundEffect?.play()
        
        let transition = SKTransition.reveal(with: .down, duration: 0.5)
        let scene = GameScene(size: size)
        view?.presentScene(scene, transition: transition)
    }
}
