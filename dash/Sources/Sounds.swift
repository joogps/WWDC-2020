import AVFoundation

struct Sounds {
    static let startSoundEffect = loadSound(fileNamed: "confirmation_001.mp3")
    
    static let difficultyIncreaseSound = loadSound(fileNamed: "confirmation_003.mp3")
    static let explosionSound = loadSound(fileNamed: "error_004.mp3")
    static let breakingSound = loadSound(fileNamed: "click_005.mp3")
    
    static let slowMotionStart = loadSound(fileNamed: "minimize_008.mp3")
    static let slowMotionTimerTick = loadSound(fileNamed: "tick_002.mp3")
    static let slowMotionTimerDone = loadSound(fileNamed: "glass_004.mp3")
    
    static let strengthStart = loadSound(fileNamed: "toggle_001.mp3")
    static let strengthEnd = loadSound(fileNamed: "error_003.mp3")
    
    static let shootSound = loadSound(fileNamed: "drop_002.mp3")
    static let superShootSound = loadSound(fileNamed: "minimize_004.mp3")
    static let errorSound = loadSound(fileNamed: "bong_001.mp3")
    
    static let goodSound = loadSound(fileNamed: "confirmation_002.mp3")
    static let badSound = loadSound(fileNamed: "error_008.mp3")
}

