//
//  CurrencyStorage.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//

import Foundation

protocol CurrencyStorage: AnyObject {
    func saveCurrency(_ Currency: Currency)
    func saveCurrencies(_ currencies: [Currency])
    func getCurrency(with id: String) -> Currency?
    func getCurrencies() -> [Currency]?
}

final class CurrencyStorageImpl: CurrencyStorage {
    private var storage: [String: Currency] = [:]

    private let syncQueue = DispatchQueue(label: "sync-cyrrency-queue")

    func saveCurrency(_ currency: Currency) {
        syncQueue.async { [weak self] in
            self?.storage[currency.id] = currency
        }
    }
    
    func saveCurrencies(_ currencies: [Currency]) {
        syncQueue.async { [weak self] in
            currencies.forEach { currency in
                self?.storage[currency.id] = currency
            }
        }
    }

    func getCurrency(with id: String) -> Currency? {
        syncQueue.sync {
            storage[id]
        }
    }
    
    func getCurrencies() -> [Currency]? {
        syncQueue.sync {
            let currencies = Array(storage.values)
            return currencies.isEmpty ? nil : currencies
        }
    }
    
    
}
