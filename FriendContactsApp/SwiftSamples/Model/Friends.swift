//
//  FriendsModel.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI
import SwiftData

@Model
class Friend {
    var name: String
    var number: String
    
    init(name: String, number: String) {
        self.name = name
        self.number = number
    }
    
    func getFirstName() -> String {
        name.split(separator: " ").first.map(String.init) ?? name
    }
}

// 1. HIAS: Create a custom class
@MainActor
final class SharedDatabase {
    let container: ModelContainer
    let context: ModelContext
    
    init(useInMemoryStore: Bool = false) throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: useInMemoryStore)
        
        container = try ModelContainer(
            for: Friend.self,
            configurations: configuration
        )
        
        context = ModelContext(container)
    }
}

struct SampleData: PreviewModifier {
    typealias Context = ModelContainer
    
    static func makeSharedContext() async throws -> Context {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Friend.self, configurations: config)
        let context = container.mainContext
        
        let currentFriends = [
            Friend(name: "Michael Bascon", number: "0917-524-0000"),
            Friend(name: "Steven Medenilla", number: "0968-439-0000")
        ]
        
        for friend in currentFriends {
            context.insert(friend)
        }
        
        try context.save()
        
        return container
    }
    
    func body(content: Content, context: Context) -> some View {
        content
            .modelContainer(context)
    }
}
