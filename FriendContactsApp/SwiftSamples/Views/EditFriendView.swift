//
//  EditFriendView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI

struct EditFriendView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var friend: Friend
    
    @State private var friendName: String = ""
    @State private var friendNumber: String = ""
    
    init(friend: Friend) {
        self.friend = friend
        
        _friendName = State(initialValue: friend.name)
        _friendNumber = State(initialValue: friend.number)
    }
    
    private var isValidEntry: Bool {
        !friendName.isEmpty && !friendNumber.isEmpty
    }
    
    var body: some View {
        NavigationStack(root: {
            Form(content: {
                Section("Personal Information", content: {
                    TextField("Name", text: $friendName)
                    TextField("Phone Number", text: $friendNumber)
                })
            })
            .navigationTitle("Edit Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                editFriendToolbar
            })
        })
    }
    
    private var editFriendToolbar: some ToolbarContent {
        Group(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                Button("Cancel", action: {
                    dismiss()
                })
            })
            
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Save", action: {
                    friend.name = friendName
                    friend.number = friendNumber
                    try? modelContext.save()
                    
                    dismiss()
                })
                .disabled(!isValidEntry)
            })
        })
    }
}
