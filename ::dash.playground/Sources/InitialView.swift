import SpriteKit
import AVFoundation

public class InitialView: SKView {
    var startSoundEffect: AVAudioPlayer!
    
    var difficultyIncreaseSound: AVAudioPlayer!
    var explosionSound: AVAudioPlayer!
    var breakingSound: AVAudioPlayer!
    
    var strengthStart: AVAudioPlayer!
    var strengthEnd: AVAudioPlayer!
    
    var slowMotionStart: AVAudioPlayer!
    var slowMotionTimerTick: AVAudioPlayer!
    var slowMotionTimerDone: AVAudioPlayer!
    
    var shootSound: AVAudioPlayer!
    var superShootSound: AVAudioPlayer!
    var errorSound: AVAudioPlayer!
    
    var goodSound: AVAudioPlayer!
    var badSound: AVAudioPlayer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let options = [.mouseMoved, .activeInKeyWindow, .activeAlways, .inVisibleRect] as NSTrackingArea.Options
        let tracker = NSTrackingArea(rect: frame, options: options, owner: self, userInfo: nil)
        
        addTrackingArea(tracker)
        
        loadSounds()
        
        let menuScene = MenuScene(size: frame.size)
        presentScene(menuScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSounds() {
        startSoundEffect = loadSound(fileNamed: "Sounds/confirmation_001.mp3")
        
        difficultyIncreaseSound = loadSound(fileNamed: "Sounds/confirmation_003.mp3")
        explosionSound = loadSound(fileNamed: "Sounds/error_004.mp3")
        breakingSound = loadSound(fileNamed: "Sounds/click_005.mp3")
        
        slowMotionStart = loadSound(fileNamed: "Sounds/minimize_008.mp3")
        slowMotionTimerTick = loadSound(fileNamed: "Sounds/tick_002.mp3")
        slowMotionTimerDone = loadSound(fileNamed: "Sounds/glass_004.mp3")
        
        strengthStart = loadSound(fileNamed: "Sounds/toggle_001.mp3")
        strengthEnd = loadSound(fileNamed: "Sounds/error_003.mp3")
        
        shootSound = loadSound(fileNamed: "Sounds/drop_002.mp3")
        superShootSound = loadSound(fileNamed: "Sounds/minimize_004.mp3")
        errorSound = loadSound(fileNamed: "Sounds/bong_001.mp3")
        
        goodSound = loadSound(fileNamed: "Sounds/confirmation_002.mp3")
        badSound = loadSound(fileNamed: "Sounds/error_008.mp3")
    }
}
