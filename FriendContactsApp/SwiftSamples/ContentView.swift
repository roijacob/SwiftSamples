//
//  ContentView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Friend.name) private var allFriends: [Friend]
    @State private var friendToEdit: Friend?
    
    var body: some View {
        NavigationStack(root: {
            friendsList
                .navigationTitle("Friends")
                .toolbar(content: {
                    // 3. HCVDPAEE: Create empty values for adding entries
                    addFriendToolbarItem
                })
            
                // 2. HCVDPAEE: Create a modal view that passes the selected data
                .sheet(
                    item: $friendToEdit,
                    onDismiss: cleanupEmptyEntries,
                    content: { friendToEdit in
                        // 4. HCVDPAEE: Modify existing values for editing entries
                        EditFriendView(friend: friendToEdit)
                            .presentationDetents([.fraction(0.30)])
                })
        })
    }
    
    var friendsList: some View {
        List(content: {
            // 1. HCVDPAEE: Display all of the data of allFriends
            ForEach(allFriends, content: { friend in
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
                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false,
                    content: {
                        Button(role: .destructive, action: {
                            modelContext.delete(friend)
                            try? modelContext.save()
                        }, label: {
                            Label("Delete", systemImage: "trash")
                        })
                    })
            })
        })
    }
    
    private var addFriendToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing, content: {
            Button(action: {
                let newFriend = Friend(name: "", number: "")
                modelContext.insert(newFriend)
                friendToEdit = newFriend
            }, label: {
                Image(systemName: "plus")
            })
        })
    }
    
    private func cleanupEmptyEntries() {
        let emptyFriends = allFriends.filter { $0.name.isEmpty && $0.number.isEmpty }
        emptyFriends.forEach(modelContext.delete)
        try? modelContext.save()
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

#Preview(traits: .modifier(SampleData())) {
    ContentView()
}
