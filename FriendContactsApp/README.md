# How to Integreate AppIntents with SwiftData

![AppIntents Logo](https://docs-assets.developer.apple.com/published/ac15ae4c94b2461ac2f70b184512193d/app-intents-hero@2x.png)

> [!TIP]
> Use the acronym **`HIAS`** to navigate within the source code.

## Prerequisites:
- Make sure you already know how to create a SwiftData application or at least the principles to integrate one into your app. You can refer to this [commit](https://github.com/roijacob/SwiftSamples/tree/56a59008a1fb8b925b4e02d9859e58e226189d39/FriendContactsApp) or read this [article](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches) to have a quick catch-up.

<br>
<br>

AppIntents provide a way to expose app functionalities within the Apple ecosystem. However, most of the tutorials for AppIntents do not even focus on SwiftData, which is the modern way to manage persistent storage across Apple devices. This is a guide on how to implement both on a simple application:

---

1. **Create a Class as a Source of Truth**: We need to create a class to establish the SwiftData object that we would expose in AppIntents. This is an example class that could even stand on its own as a snippet.

```swift
@MainActor
final class SharedDatabase {
    let container: ModelContainer
    let context: ModelContext
    
    init(useInMemoryStore: Bool = false) throws {
        // Define configurations
        let configuration = ModelConfiguration(isStoredInMemoryOnly: useInMemoryStore)
        
        // Create a configured model container
        container = try ModelContainer(
            for: Friend.self,
            configurations: configuration
        )
        
        // Contextualize model container
        context = ModelContext(container)
    }
}
```

I have tried using the ModelContainer as it is already a class by implementation, but I find that the data is not in sync when performing CRUD operations in the Shortcuts app and in the app itself.

<br>
<br>

2. **Set up App Dependencies**: Setting up the app dependencies should be implemented in the App protocol, like this, for example:

```swift
@main
struct SwiftSamplesApp: App {
    let database: SharedDatabase
    
    init() {
        // Initialize the database
        do {
            database = try SharedDatabase()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
        
        // Use separate variable to avoid capturing 'self'
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
```

In the code, we are setting the database to use the custom class we have already created. Then, we use a local variable to store the reference, and we use it as a dependency.

> [!WARNING]
> **You need to set up AppIntents in the App protocol.** You can essentially bypass this, and it is definitely possible to create an AppIntent without setting up the App protocol. But it is important to think that `AppDependencyManager` was not created for nothing. All of the sample apps in AppIntents use the `AppDependencyManager` for initialization, and for the sake of safety, it is much better to create AppIntents in this way, following the Apple engineers.

<br>
<br>

3. **Create App Intents**: After setting up the previous steps, you are on your way to create your own App Intents, like this, for example:

```swift
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

    @Dependency
    private var swiftDatabase: SharedDatabase
}
```

Make sure that you use the `@Dependency` macro that points to the custom SwiftData class.