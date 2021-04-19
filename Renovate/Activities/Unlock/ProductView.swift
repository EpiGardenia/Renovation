//
//  ProductView.swift
//  inAppPurchase
//
//  Created by T  on 2021-04-13.
//

import SwiftUI
import StoreKit

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
   // let product: SKProduct
    let products: [SKProduct]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Renovations")
                    .font(.headline)
                    .padding(.top, 10)
                
                Text(String.localizing("You can add three renovation projects for free, or choose below alternatives to add unlimited renovations", tableName: "IAP"))
                Text(String.localizing("If you already bought the unlock on another device, press Restore Purchases.", tableName: "IAP"))

                Button("Unlock for \(products[0].localizedPrice) one time", action: {unlock(0)})
                    .buttonStyle(PurchaseButton())

                Button("Unlock for \(products[1].localizedPrice) per month", action: {unlock(1)})
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(PurchaseButton())

            }
        }
    }

    func unlock(_ choice: Int) {
        unlockManager.buy(product: products[choice])
    }

}


