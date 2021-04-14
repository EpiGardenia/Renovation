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
    let product: SKProduct


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Renovations")
                    .font(.headline)
                    .padding(.top, 10)
                Text("You can add three renovations for free, or pay \(product.localizedPrice) to add unlimited renovations")
                Text("If you already bought the unlock on another device, press Restore Purchases.")

                Button("Unlock for \(product.localizedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(PurchaseButton())

            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }

}


