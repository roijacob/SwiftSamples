//
//  ContentView.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/7/24.
//

import SwiftUI
import StoreKit
import Observation


let credits = [
    "com.roijacob.currency.gold",
    "com.roijacob.currency.gem",
    "com.roijacob.currency.platinum"
]


@Observable
class StoreProducts {
    var products: [Product] = []
    
    init() {
        // 1. HIIAPUSA: Retrieve the in-app products
        Task(operation: {
            do {
                products = try await Product.products(for: credits)
            } catch {
                print("Error loading products: \(error)")
                products = []
            }
        })
    }
    
    // 3. HIIAPUSA: Purchase a product
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            try await handleVerification(verification)
        case .userCancelled, .pending:
            print("You cancelled the transaction.")
        default:
            return
        }
    }
    
    // 4. HIIAPUSA: Verify the purchase
    func handleVerification(_ verification: VerificationResult<StoreKit.Transaction>) async throws {
        switch verification {
        case .verified(let transaction):
            
            // 5. HIIAPUSA: Deliver the paid product/service
            print("Transaction Done!")
            
            // 6. HIIAPUSA: Finish the transaction
            await transaction.finish()
        
        case .unverified:
            fatalError("Unverified Transaction!")
        }
    }
}


struct ContentView: View {
    @State private var store = StoreProducts()
    
    var sortedProducts: [Product] {
        store.products.sorted(by: { $0.price < $1.price })
    }
    
    // 2. HIIAPUSA: Display the in-app products
    var body: some View {
        VStack(content: {
            ForEach(sortedProducts) { product in
                Button(action: {
                    Task {
                        try? await store.purchase(product)
                    }
                }, label: {
                    Text(product.displayName)
                })
            }
        })
    }
}


#Preview {
    ContentView()
}
