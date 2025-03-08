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
    
    // 1. HNAB: The struct would always require a friend parameter
    @Bindable var friend: Friend
    
    // 2. HNAB: Create a @State with empty values
    @State private var friendName: String = ""
    @State private var friendNumber: String = ""
    
    init(friend: Friend) {
        self.friend = friend
        
        // 3.1. HNAB: Set the initial value of the @State
        // 3.2. HNAB: Using the values of the @Bindable
        _friendName = State(initialValue: friend.name)
        _friendNumber = State(initialValue: friend.number)
    }
    
    private var isValidEntry: Bool {
        !friendName.isEmpty && !friendNumber.isEmpty
    }
    
    var body: some View {
        NavigationStack(root: {
            Form(content: {
                // 4. HNAB: Text fields use the @State values for modification
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
        Group {
            ToolbarItem(placement: .topBarLeading, content: {
                Button("Cancel", action: {
                    dismiss()
                })
            })
            
            ToolbarItem(placement: .topBarTrailing, content: {
                // 5. HNAB: Update the @Bindable with the new/modified values of @State
                Button("Save", action: {
                    friend.name = friendName
                    friend.number = friendNumber
                    try? modelContext.save()
                    
                    dismiss()
                })
                // 5. HCVDPAEE: Disable the save button if entries are null
                .disabled(!isValidEntry)
            })
        }
    }
}
