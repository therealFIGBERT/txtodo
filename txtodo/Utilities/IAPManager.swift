//
//  IAPManager.swift
//  txtodo
//
//  Created by FIGBERT on 5/6/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//

import Foundation
import StoreKit

fileprivate func getProductIDs() -> [String]? {
    guard let url = Bundle.main.url(forResource: "IAP_ProductIDs", withExtension: "plist") else { return nil }
    do {
        let data = try Data(contentsOf: url)
        let productIDs = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String] ?? []
        return productIDs
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

class IAPManager: NSObject, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    
    func getProducts(withHandler productsReceiveHandler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
        onReceiveProductsHandler = productsReceiveHandler
        guard let productIDs = getProductIDs() else {
            productsReceiveHandler(.failure(.noProductIDsFound))
            return
        }
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    func getPriceFormatted(for product: SKProduct) -> String? {
        let roundedPrice = product.price.doubleValue.rounded()
        let formatter = NumberFormatter()
        formatter.locale = product.priceLocale
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = String(roundedPrice).contains(".00") ? 0 : 2
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: roundedPrice))
    }
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        onBuyProductHandler = handler
    }
    
    private override init() {
        super.init()
    }
}

extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
            case .noProductsFound: return "No In-App Purchases were found."
            case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
            case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        if products.count > 0 {
            onReceiveProductsHandler?(.success(products))
        } else {
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
}

extension IAPManager {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
                case .purchased:
                    onBuyProductHandler?(.success(true))
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .restored:
                    break
                case .failed:
                    if let error = transaction.error as? SKError {
                        if error.code != .paymentCancelled {
                            onBuyProductHandler?(.failure(error))
                        } else {
                            onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                        }
                        print("IAP Error:", error.localizedDescription)
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
}
