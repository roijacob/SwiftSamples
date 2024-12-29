# How to Use SwiftData

![SwiftData Logo](https://developer.apple.com/news/images/og/swiftdata-og-twitter.png)

> [!TIP]
> Use the acronym **`HUSD`** to navigate within the source code.

SwiftData is the modern way to persist data. It is worth learning this framework because inevitably, this will become the default way (someday) to persist data when creating applications on Apple platforms. This is a very basic tutorial to get up and running with SwiftData. For more information, refer to this [guide](https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches).

- Create a SwiftData model by annotating a class with the `@Model` macro.  
- Create the SwiftData storage by adding a `modelContainer` in the App protocol.  
- Fetch the data by using the `@Query` macro.

<br>

# How to Preview SwiftData Contents

![SwiftData Logo](https://developer.apple.com/news/images/og/swiftdata-og-twitter.png)

> [!TIP]
> Use the acronym **`HPSDC`** to navigate within the source code.

WWDC 24 released some new additions to SwiftData, and it includes a better previewing experience for SwiftData contents. This uses the `PreviewModifier` protocol to implement. For more information, refer to this WWDC24 [video](https://developer.apple.com/videos/play/wwdc2024/10137/?time=401).

- Create a struct that conforms to the `PreviewModifier` protocol.  
- Use the `makeSharedContext` to set up the SwiftData infrastructure.  
- Use the `body` to integrate the model container into the preview content.  
- Use the struct as a traits argument in the `#Preview` macro.