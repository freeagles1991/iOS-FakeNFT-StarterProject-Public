final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var nftCollectionsService: NftCollectionsService {
        NftCollectionsServiceImpl(networkClient: networkClient)
    }
    
    var userProfileService: UserProfileServiceProtocol {
        UserProfileService(networkClient: networkClient)
    }
}
