import SpriteKit

enum Categories: UInt32 {
    case Player = 1
    case Projectile = 2
    case Enemy = 4
    case EnemyProjectile = 8
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

func animateLabelFont(label: SKLabelNode, fonts: Array<String>, timeInterval: TimeInterval, withFeedback: Bool = false, callback: (() -> Void)? = nil) {
    if fonts.count > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            label.fontName = fonts[0]
            var newFonts = fonts.map { $0 }
            newFonts.remove(at: 0)
            animateLabelFont(label: label, fonts: newFonts, timeInterval: timeInterval, callback: callback)
            if withFeedback {
                hapticFeedback()
            }
            }
    } else {
        callback?()
    }
}

func hapticFeedback() {
    let feedbackPerformer = NSHapticFeedbackManager.defaultPerformer
    feedbackPerformer.perform(.generic, performanceTime: .now)
}
