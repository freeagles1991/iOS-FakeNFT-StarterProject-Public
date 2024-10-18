//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//
import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol CurrencyService {
    func loadCurrencyList(completion: @escaping CurrenciesCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient
    private let storage: CurrencyStorage

    init(networkClient: NetworkClient, storage: CurrencyStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCurrencyList(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesListRequest()
        networkClient.send(request: request, type: [Currency].self) { [weak storage] result in
            switch result {
            case .success(let currencies):
                storage?.saveCurrencies(currencies)
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
