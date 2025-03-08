//
//  AppIntents.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 1/4/25.
//

import AppIntents
import SwiftData

// Intent to add a friend entry
struct AddFriendIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Friend Entry"
    
    static var description: IntentDescription = IntentDescription("Add a new friend to your contacts")

    @Parameter(title: "Name")
    var enteredName: String
    
    @Parameter(title: "Phone Number")
    var enteredNumber: String
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let newFriend = Friend(name: enteredName, number: enteredNumber)
        swiftDatabase.context.insert(newFriend)
        try swiftDatabase.context.save()
        return .result()
    }

    // 3. HIAS: Use the model container of the custom class
    @Dependency
    private var swiftDatabase: SharedDatabase
}

// Intent to count the number of entries
struct CountFriendsIntent: AppIntent {
    static var title: LocalizedStringResource = "Count Friends"
    
    static var description: IntentDescription = IntentDescription("Count the total number of friends in your contacts")
    
    @MainActor
    func perform() async throws -> some ReturnsValue<Int> & ProvidesDialog {
        let descriptor = FetchDescriptor<Friend>()
        let count = try swiftDatabase.context.fetchCount(descriptor)
        return .result(value: count, dialog: "You have \(count) people in your contacts")
    }
    
    // 3. HIAS: Use the model container of the custom class
    @Dependency
    private var swiftDatabase: SharedDatabase
}

// Expose the app intents in the Shortcuts app
struct FriendsShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddFriendIntent(),
            phrases: [
                "Add a new friend to \(.applicationName)",
                "Add friend to \(.applicationName)",
                "Create new contact in \(.applicationName)"
            ],
            shortTitle: "Add a Friend",
            systemImageName: "person.badge.plus"
        )
        
        AppShortcut(
            intent: CountFriendsIntent(),
            phrases: [
                "Count my friends in \(.applicationName)",
                "How many friends do I have in \(.applicationName)",
                "Show number of contacts in \(.applicationName)"
            ],
            shortTitle: "Count Friends",
            systemImageName: "person.fill.questionmark.rtl"
        )
    }
}
