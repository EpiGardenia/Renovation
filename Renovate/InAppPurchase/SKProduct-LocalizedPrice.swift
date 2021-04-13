//
//  SKProduct-LocalizedPrice.swift
//  inAppPurchase
//
//  Created by T  on 2021-04-13.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
