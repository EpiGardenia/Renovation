//
//  UnlockView.swift
//  inAppPurchase
//
//  Created by T  on 2021-04-13.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager

    var body: some View {
        VStack {
            switch unlockManager.requestState {
                case .loaded(let products):
                    ProductView(products: products)
                case .failed(_):
                    Text("Sorry, there was an error loadng the store. Please try again later.")
                case .loading:
                    ProgressView("Loading…")
                case .purchased:
                    Text("Thank you!")
                case .deferred:
                    Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
            }

            Button("Dismiss", action: dismiss)
        }
        .padding()
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }


    func dismiss() {
        presentationMode.wrappedValue.dismiss()

    }
}


