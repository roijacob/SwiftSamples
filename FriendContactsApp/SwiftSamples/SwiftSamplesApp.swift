//
//  SwiftSamplesApp.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI

@main
struct SwiftSamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Friend.self])
        }
    }
}
