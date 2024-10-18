final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let currencyStorage: CurrencyStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        currencyStorage: CurrencyStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.currencyStorage = currencyStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var currencyService: CurrencyService {
        CurrencyServiceImpl(networkClient: networkClient, storage: currencyStorage)
    }
}
