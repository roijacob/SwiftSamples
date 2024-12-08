# How to Add a Listener for StoreKit Transactions

![StoreKit Logo](https://developer.apple.com/news/images/og/storekit-og.jpg)

Listeners in StoreKit are very important; it allows you to create a transaction on an Apple device, such as an iPhone, and access the same app such as an iPad that has all of the context about the transaction that you made on your iPhone. As such, this synchronizes the purchasing for you, so that no matter where you made the purchase, it would always be updated across Apple devices.

Use the acronym `HALST` to navigate within the source code.

<br>

**IMPLEMENTATION:** Add a [function](SwiftSamples/PurchaseLogic.swift#L47) that listens for the transactions, and [call](SwiftSamples/ContentView.swift#L82) that function once the view (that serves as the entry point) appears in your app.

<br>

## Prerequisite:
- Make sure you have already set up StoreKit testing in Xcode. Refer to this [article](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode) for more details.

<br>

## Additional Information
- You can use an environment variable to initiate a StoreKit purchase. <sup>[1](https://developer.apple.com/documentation/storekit/purchaseaction)</sup>

- `@AppStorage` only works in Views; you would receive a weird `Invalid Redeclaration` error if you put it in a class.
