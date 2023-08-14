//
//  HostingWindowAccessor.swift
//  readySet
//
//  Created by João Gabriel Pozzobon dos Santos on 14/08/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func accessHostingWindow(_ window: Binding<NSWindow?>,
                             onAccess: @escaping (NSWindow) -> () = { _ in }) -> some View {
        self.background {
            if window.wrappedValue == nil {
                HostingWindowAccessor(window: window, onAccess: onAccess)
            }
        }
    }
}

fileprivate struct HostingWindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    var onAccess: (NSWindow) -> ()
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
            if let window {
                onAccess(window)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
