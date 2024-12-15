# How to Create Custom StoreKit Product Views

![StoreKit Logo](https://developer.apple.com/news/images/og/storekit-og.jpg)

StoreKit has its own views compatible with SwiftUI, such as StoreView, ProductView, and SubscriptionStoreView, which were introduced at WWDC 2023. However, these views come with a default style that may or may not be appealing to developers. Fortunately, StoreKit views can be customized to suit your own preferences by using the `ProductViewStyle` protocol.

---

Use the acronym `HCCSPV` to navigate within the source code.

<br>

> [!NOTE]
> **IMPLEMENTATION:**
> 1. [CODE](SwiftSamples/ContentView.swift#L92): Create a custom `ProductViewStyle` struct.
> 2. [CODE](SwiftSamples/ContentView.swift#L95): Define the behavior within the `makeBody` function.
> 3. [CODE](SwiftSamples/ContentView.swift#L99): Implement a `configuration.state` property to specify the custom view for each state.
> 4. [CODE](SwiftSamples/ContentView.swift#L65): Call the custom struct in a StoreKit view.

<br>

## Prerequisite:
- Make sure you have already set up StoreKit testing in Xcode. Refer to this [article](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) for more details.

- Make sure you are using a [StoreKit View](https://developer.apple.com/documentation/storekit/storekit-views) such as **StoreView**, **ProductView**, or **SubscriptionStoreView**.

- Use a custom icon. You can upload the image in the StoreKit configuration file and utilize it by setting `prefersPromotionalIcon = true`. However, it will not generate the complete image in a View. Instead, store the image in the Assets folder and use that as the custom icon. This is also the approach taken in Backyard Birds at WWDC 2023.
