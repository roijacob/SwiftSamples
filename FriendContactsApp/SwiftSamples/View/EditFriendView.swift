//
//  EditFriendView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/28/24.
//

import SwiftUI

struct EditFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var friend: Friend
        
    var body: some View {
        NavigationStack(root: {
            Form(content: {
                Section("Personal Information", content: {
                    TextField("Name", text: $friend.name)
                    TextField("Phone Number", text: $friend.number)
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
                    dismiss()
                })
            })
        })
    }
}
