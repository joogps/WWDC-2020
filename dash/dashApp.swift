//
//  dashApp.swift
//  dash
//
//  Created by João Gabriel Pozzobon dos Santos on 14/08/23.
//

import SwiftUI

@main
struct dashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizabilityContentSize()
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
