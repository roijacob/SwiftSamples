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
        .onInAppPurchaseCompletion { product, purchaseResult in
            
            // 1. HDPPSUO: Pattern match on the purchaseResult variable
            if case .success(.success(.verified(let transaction))) = purchaseResult {
                
                // 2. HDPPSUO: Deliver the paid entitlement
                deliverEntitlements(transaction)
                
                // 3. HDPPSUO: Mark the transaction as finished
                await transaction.finish()
            }
        }
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
            ProductView(id: product.id, prefersPromotionalIcon: true)
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
        
        _ = listenForTransactions
    }
}


#Preview {
    ContentView()
}
