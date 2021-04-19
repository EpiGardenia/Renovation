//
//  UnlockManager.swift
//  inAppPurchase
//
//  Created by T  on 2021-04-13.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading // about to start, but not yet get request
        case loaded(SKProduct)  // request from apple which products are available from our store for purchase
        case failed(Error?)  // sth went wrong
        case purchased // successfully buy IAP or restore IAP
        case deferred  // current user doesn't have permission to buy
    }

    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }


    @Published var requestState = RequestState.loading

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    init(dataController: DataController) {
        self.dataController = dataController
        let productIDs = Set(["Freedom.Renovate.unlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)

        super.init()


        SKPaymentQueue.default().add(self)  // Tell us if anything happen

        guard dataController.fullVersionUnlocked == false else { return }
        request.delegate = self
        request.start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }


    // when app is termniated, one should remove oneself from observer queue


    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                    case .purchased, .restored:
                        self.dataController.fullVersionUnlocked = true
                        self.requestState = .purchased
                        queue.finishTransaction(transaction)
                    case .failed:
                        if let product = loadedProducts.first {
                            self.requestState = .loaded(product)
                        } else {
                            self.requestState = .failed(transaction.error)
                        }

                        queue.finishTransaction(transaction)

                    case .deferred:
                        self.requestState = .deferred

                    default:
                        break

                }
            }
        }

    }

    // Change this must be in main stream
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loadedProducts = response.products
            guard let unlock = self.loadedProducts.first else {
                print("ALERT: Missing load product ")
                self.requestState = .failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("ALERT: received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }


            self.requestState = .loaded(unlock)

        }

    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

}

