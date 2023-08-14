import SpriteKit
import SwiftUI

struct SceneView: NSViewRepresentable {
    typealias UIViewType = SKView
    
    var skScene: SKScene!
    var size: CGSize
    
    init(size: CGSize) {
        skScene = MenuScene(size: size)
        self.size = size
    }
    
    class Coordinator: NSObject {
        var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.scene = self.skScene
        return coordinator
    }
    
    func makeNSView(context: Context) -> SKView {
        let view = SKView(frame: .init(origin: .zero, size: size))
        
        let options = [.mouseMoved, .activeInKeyWindow, .activeAlways, .inVisibleRect] as NSTrackingArea.Options
        let tracker = NSTrackingArea(rect: .init(origin: .zero, size: size), options: options, owner: view, userInfo: nil)
        
        view.addTrackingArea(tracker)
        
        return view
    }
    
    func updateNSView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}
