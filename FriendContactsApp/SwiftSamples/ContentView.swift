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
            HomeView(friendToEdit: $friendToEdit)
                .navigationTitle("My Friends")
                .toolbar(content: {
                    addFriendToolbarItem
                })
                .sheet(
                    item: $friendToEdit,
                    onDismiss: cleanupEmptyEntries,
                    content: { friendToEdit in
                        EditFriendView(friend: friendToEdit)
                            .presentationDetents([.fraction(0.30)])
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

#Preview(traits: .modifier(SampleData())) {
    ContentView()
}
