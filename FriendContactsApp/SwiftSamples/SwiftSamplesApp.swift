//
//  SwiftSamplesApp.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI
import AppIntents

@main
struct SwiftSamplesApp: App {
    let database: SharedDatabase
    
    // 2. HIAS: Create a dependenc to the custom class
    init() {
        do {
            database = try SharedDatabase()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
        
        let sharedDB = database
        AppDependencyManager.shared.add(dependency: sharedDB)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Friend.self])
        }
    }
}
