//
//  ContentView.swift
//  dash
//
//  Created by João Gabriel Pozzobon dos Santos on 14/08/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var size = CGSize(width: 800, height: 600)
    
    @State var window: NSWindow?
    
    @State var skipped = false
    
    var body: some View {
        ZStack {
            if skipped {
                SceneView(size: size)
                    .clipShape(RoundedRectangle(cornerRadius: 7.0, style: .continuous))
                    .transition(.move(edge: .bottom))
            } else {
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            skipped = true
                        }
                    
                    VStack(spacing: 24) {
                        Text("This experience was created for the WWDC20 Swift Student Challenge, originally as an Xcode Playground.")
                        Text("Now, it has been made available as a macOS app, completely unmodified.")
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .medium))
                    .padding(64)
                    .padding(.horizontal, 64)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()+8.5) {
                            skipped = true
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.9), value: skipped)
        .frame(width: size.width, height: size.height)
        .accessHostingWindow($window) { window in
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
