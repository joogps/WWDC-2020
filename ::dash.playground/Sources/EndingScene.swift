import SpriteKit

let goodPhrases = ["you rocked it", "awesome", "impressive", "good game"]
let badPhrases = ["you can do better", "i believe in u", "try harder next time", "don't give up", "give it another shot"]

public class EndingScene: SKScene {
    var title: SKLabelNode!
    var subTitle: SKLabelNode!
    
    var score: Int!
    
    var canMove = false
    
    public init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        backgroundColor = .white
        
        title = SKLabelNode()
        title.text = (score >= 15 ? goodPhrases : badPhrases).randomElement()!
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
        
        let transition = SKTransition.reveal(with: .down, duration: 0.5)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition: transition)
    }
}
