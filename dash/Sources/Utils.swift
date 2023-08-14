import SpriteKit
import AVFoundation

enum Categories: UInt32 {
    case Player = 1
    case PlayerProjectile = 2
    case Enemy = 4
    case EnemyProjectile = 8
    case StrengthPowerUp = 16
    case SlowMotionPowerUp = 32
}

func helveticaNeueFonts() -> Array<String> {
    let fonts = NSFontManager.shared.availableFonts
    var helveticaNeueFonts = [String]()

    for font in fonts {
        if font.contains("HelveticaNeue-") {
            helveticaNeueFonts.append(font)
        }
    }

    return helveticaNeueFonts
}

func animateLabelFont(label: SKLabelNode, fonts: Array<String>, timeInterval: TimeInterval, callback: (() -> Void)? = nil) {
    if fonts.count > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            label.fontName = fonts[0]
            var newFonts = fonts.map { $0 }
            newFonts.remove(at: 0)
            animateLabelFont(label: label, fonts: newFonts, timeInterval: timeInterval, callback: callback)
        }
    } else {
        callback?()
    }
}

func hapticFeedback() {
    let feedbackPerformer = NSHapticFeedbackManager.defaultPerformer
    feedbackPerformer.perform(.generic, performanceTime: .now)
}

func loadSound(fileNamed: String) -> AVAudioPlayer? {
    if let path = Bundle.main.path(forResource: fileNamed, ofType: nil) {
        let url = URL(fileURLWithPath: path)
        var audioPlayer = AVAudioPlayer()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            return nil
        }
        
        return audioPlayer
    }
    
    return nil
}
