//
//  SwiftSamplesApp.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 11/21/24.
//

import SwiftUI

@main
struct SwiftSamplesApp: App {
    var body: some Scene {
        WindowGroup {
//            // Application 1
//            FriendsListView()
//                .modelContainer(for: Friends.self)
            
            // Application 2
            ToDoContentView()
                .modelContainer(for: Todo.self)
        }
    }
}
