//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Дима on 18.10.2024.
//
import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void
typealias SetCurrencyIDCompletion = (Result<SetCurrencyIDResponse, Error>) -> Void

protocol CurrencyService {
    func loadCurrencyList(completion: @escaping CurrenciesCompletion)
    func setCurrencyIDBeforePayment(_ currencyID: String, completion: @escaping SetCurrencyIDCompletion)
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
    
    func setCurrencyIDBeforePayment(_ currencyID: String, completion: @escaping SetCurrencyIDCompletion) {
        let request = SetCurrencyIDBeforePaymentRequest(id: currencyID)
        
        networkClient.send(request: request, type: SetCurrencyIDResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
