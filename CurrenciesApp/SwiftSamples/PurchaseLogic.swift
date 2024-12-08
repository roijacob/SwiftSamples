//
//  PurchaseLogic.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/8/24.
//

import StoreKit


extension ContentView {
    func handlePurchaseResult(_ purchaseResult: Product.PurchaseResult) async {
        switch purchaseResult {
        case .success(let verificationResult):
            await handleVerification(verificationResult)
        case .userCancelled, .pending:
            print("Transaction Not Successful!")
        default:
            break
        }
    }
    
    func handleVerification(_ verificationResult: VerificationResult<StoreKit.Transaction>) async {
        switch verificationResult {
        case .verified(let transaction):
            deliverEntitlements(transaction)
            
            print("Transaction Done!")
            
            await transaction.finish()
            
        case .unverified:
            print("Unverified Transaction!")
        }
    }
    
    func deliverEntitlements(_ transaction: Transaction) {
        if transaction.productID == "com.roijacob.currency.gold" {
            currentGold += 1
        } else if transaction.productID == "com.roijacob.currency.gem" {
            currentGem += 1
        } else if transaction.productID == "com.roijacob.currency.platinum" {
            currentPlatinum += 1
        }
    }
    
    // 1. HALST: Iterate through any transactions that don't come from a direct call to `purchase()`.
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await deliverEntitlements(transaction)
                    await transaction.finish()
                case .unverified:
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func resetCurrencies() {
        currentGold = 0
        currentGem = 0
        currentPlatinum = 0
    }
}

