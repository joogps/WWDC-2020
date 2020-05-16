//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

let view = SKView(frame: CGRect(x: 0 , y: 0, width: 800, height: 600))
let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.inVisibleRect] as NSTrackingArea.Options
let tracker = NSTrackingArea(rect: view.frame, options: options, owner: view, userInfo: nil)

view.addTrackingArea(tracker)

let scene = MenuScene(size: view.bounds.size)
view.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = view
