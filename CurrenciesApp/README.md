# How to Deliver Paid Products and Services Using `onInAppPurchaseCompletion`

![StoreKit Logo](https://developer.apple.com/news/images/og/storekit-og.jpg)

- `onInAppPurchaseCompletion` is the SwiftUI way to perform functionalities after a user makes a purchase in your app. 

- For example, if a user purchases a paid item, you can create a function to deliver the paid item within the `onInAppPurchaseCompletion` block.

- This is a significant improvement compared to manually writing your own payment handler and verification functions using the StoreKit API. See this [commit](https://github.com/roijacob/SwiftSamples/tree/ce99d9416046ce2357bad03e20a518f55a16f945) for more details.

---

Use the acronym `HDPPSUO` to navigate within the source code.

<br>

**IMPLEMENTATION:** Get the [transaction data type](SwiftSamples/ContentView.swift#L41) for every purchase that occurs, then [deliver the paid product or service](SwiftSamples/ContentView.swift#L44) to the users. After that, make sure to always [finish the transaction](SwiftSamples/ContentView.swift#L47).

<br>

## Prerequisite:
- Make sure you have already set up StoreKit testing in Xcode. Refer to this [article](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) for more details.

- Make sure you are using a [StoreKit View](https://developer.apple.com/documentation/storekit/storekit-views) for the `onInAppPurchaseCompletion` to work, such as **StoreView**, **ProductView**, or **SubscriptionStoreView**.
