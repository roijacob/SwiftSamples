//
//  ContentView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // 3. HUSD: Retrieve the data from the model container
    @Query(sort: \Friend.name) var allFriends: [Friend]
    @State private var friendToEdit: Friend?
    
    var body: some View {
        NavigationStack(root: {
            friendsList
                .navigationTitle("Friends")
                .sheet(item: $friendToEdit, content: { friendToEdit in
                    EditFriendView(friend: friendToEdit)
                        .presentationDetents([.fraction(0.30)])
                })
        })
    }
    
    var friendsList: some View {
        List(allFriends, rowContent: { friend in
            VStack(alignment: .leading, content: {
                Text(friend.name)
                    .font(.headline)
                Text(friend.number)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            .onTapGesture(perform: {
                friendToEdit = friend
            })
        })
    }
}

// 1. HPSDC: Create a struct that conforms to PreviewModifier
struct SampleData: PreviewModifier {
    typealias Context = ModelContainer
    
    static func makeSharedContext() async throws -> Context {
        
        // 2. HPSDC: Setup model configuration
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        // 3. HPSDC: Setup model storage
        let container = try ModelContainer(for: Friend.self, configurations: config)
        
        // 4. HPSDC: Setup model workspace
        let context = container.mainContext
        
        // 5. HPSDC: Create sample data
        let currentFriends = [
            Friend(name: "Michael Bascon", number: "0917-524-0000"),
            Friend(name: "Steven Medenilla", number: "0968-439-0000")
        ]
        
        // 6. HPSDC: Insert data in model container
        for friend in currentFriends {
            context.insert(friend)
        }
        
        try context.save()
        
        return container
    }
    
    // 7. HPSDC: Use the sample data
    func body(content: Content, context: Context) -> some View {
        content
            .modelContainer(context)
    }
}

// 8. HPSDC: Use as an argument to the #Preview macro
#Preview(traits: .modifier(SampleData())) {
    ContentView()
}
