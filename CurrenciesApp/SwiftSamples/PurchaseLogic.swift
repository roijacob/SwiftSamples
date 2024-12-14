//
//  PurchaseLogic.swift
//  SwiftSamples
//
//  Created by Roi Jacob on 12/8/24.
//

import StoreKit


extension ContentView {
    func deliverEntitlements(_ transaction: Transaction) {
        switch transaction.productID {
        case "com.roijacob.currency.gold":
            currentGold += 1
        case "com.roijacob.currency.gem":
            currentGem += 1
        case "com.roijacob.currency.platinum":
            currentPlatinum += 1
        default:
            break
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await deliverEntitlements(transaction)
                    await transaction.finish()
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
