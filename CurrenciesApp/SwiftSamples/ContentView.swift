//
//  ContentView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/7/24.
//

import SwiftUI
import StoreKit


let credits = [
    "com.roijacob.currency.gold",
    "com.roijacob.currency.gem",
    "com.roijacob.currency.platinum"
]


struct ContentView: View {
    @Environment(\.purchase) private var purchase
    
    @State private var products: [Product] = []

    @AppStorage("gold") var currentGold: Int = 0
    @AppStorage("gem") var currentGem: Int = 0
    @AppStorage("platinum") var currentPlatinum: Int = 0
    
    var sortedProducts: [Product] {
        products.sorted(by: { $0.price < $1.price })
    }
    
    var body: some View {
        VStack(content: {
            headerView
            Spacer()
            purchaseButtons
            Spacer()
            footerView
        })
        .task(loadProducts)
    }
    
    var headerView: some View {
        HStack(content: {
            Text("Gold: \(currentGold)")
            Spacer()
            Text("Gem: \(currentGem)")
            Spacer()
            Text("Platinum: \(currentPlatinum)")
        })
        .padding()
    }
    
    var purchaseButtons: some View {
        ForEach(sortedProducts, content: { product in
            Button(action: {
                Task(operation: {
                    let purchaseResult = try await purchase(product)
                    await handlePurchaseResult(purchaseResult)
                })
            }, label: {
                Text(product.displayName)
            })
        })
    }
    
    var footerView: some View {
        Button(action: resetCurrencies, label: {
            Text("Reset Currencies")
        })
    }
    
    @Sendable
    private func loadProducts() async {
        do {
            products = try await Product.products(for: credits)
        } catch {
            print("Error loading products: \(error)")
            products = []
        }
        
        // 2. HALST: Listen for transactions every time ContentView appears on screen
        _ = listenForTransactions
    }
}


#Preview {
    ContentView()
}
