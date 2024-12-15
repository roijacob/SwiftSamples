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
            if case .success(.success(.verified(let transaction))) = purchaseResult {
                deliverEntitlements(transaction)
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
            ProductView(id: product.id, icon: {
                Image("\(product.displayName)")
                    .resizable()
            })
            
            // 4. HCCSPV: Call the custom ProductViewStyle in a StoreKit view
            .productViewStyle(MiscritsProductStyle())
            
            .padding()
        })
    }
    
    var footerView: some View {
        Button(action: resetCurrencies, label: {
            Text("Reset Currencies")
                .bold()
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

// 1. HCCSPV: Create a custom struct that conforms to ProductViewStyle protocol
struct MiscritsProductStyle: ProductViewStyle {
    
    // 2. HCCSPV: Define the configurations (product, state, or hasCurrentEntitlement)
    func makeBody(configuration: Configuration) -> some View {
        switch configuration.state {
            
        // 3. HCCSPV: Create the custom view in the success state
        case .success(let product):
            customProductView(product: product, configuration: configuration)
        
        case .loading, .unavailable, .failure:
            Text("An error occurred")
        @unknown default:
            fatalError()
        }
    }
    
    @ViewBuilder
    private func customProductView(product: Product, configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.icon
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
            
            VStack(alignment: .center, spacing: 10) {
                Text(product.displayName)
                    .bold()
                Button(product.displayPrice) {
                    configuration.purchase()
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 3)
        )
    }
}


#Preview {
    ContentView()
}
