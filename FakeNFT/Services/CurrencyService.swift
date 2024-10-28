import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void
typealias SetCurrencyIDCompletion = (Result<SetCurrencyIDResponse, Error>) -> Void
typealias PutOrderAndPayCompletion = (Result<PutOrderAndPayResponse, Error>) -> Void

protocol CurrencyService {
    func loadCurrencyList(completion: @escaping CurrenciesCompletion)
    func setCurrencyIDBeforePayment(_ currencyID: String, completion: @escaping SetCurrencyIDCompletion)
    func sendPutOrderAndPayRequest(nfts: [String], completion: @escaping PutOrderAndPayCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient
    private let storage: CurrencyStorage

    init(networkClient: NetworkClient, storage: CurrencyStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCurrencyList(completion: @escaping CurrenciesCompletion) {
        if let currencies = storage.getCurrencies() {
            completion(.success(currencies))
            return
        }
        
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
    
    func sendPutOrderAndPayRequest(
        nfts: [String],
        completion: @escaping PutOrderAndPayCompletion
    ) {
        let dto = PutOrderAndPayDtoObject(nfts: nfts)
        let request = PutOrderAndPayRequest(dto: dto)
        networkClient.send(request: request, type: PutOrderAndPayResponse.self) { result in
            switch result {
            case .success(let putResponse):
                print("CurrencyServiceImpl: оплачены nft \(putResponse.nfts)")
                completion(.success(putResponse))
            case .failure(let error):
                print("CurrencyServiceImpl: ошибка оплаты \(error)")
                completion(.failure(error))
            }
        }
    }
}
