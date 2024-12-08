# How to Implement In-App Purchases Using StoreKit API

![StoreKit Logo](https://developer.apple.com/news/images/og/storekit-og.jpg)

Use the code `HIIAPUSA` to navigate within the source code.

The solution creates an [observable class](SwiftSamples/ContentView.swift#L20) where it stores all of the properties and methods related to the in-app products. This class is then exposed in the [View struct](SwiftSamples/ContentView.swift#L66) to display the products via [Text](SwiftSamples/ContentView.swift#L82) and provide the functionality for purchase using [`store.purchase`](SwiftSamples/ContentView.swift#L79).

## Prerequisites:
- Make sure you have already set up StoreKit testing in Xcode. Refer to this [article](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) for more details.
