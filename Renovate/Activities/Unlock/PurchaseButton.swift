//
//  SwiftUIView.swift
//  inAppPurchase
//
//  Created by T  on 2021-04-13.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 200, minHeight: 44)
            .background(Color("Light Blue"))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)

    }
}
