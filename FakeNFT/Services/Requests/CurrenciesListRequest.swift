import Foundation

struct CurrenciesListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var dto: Dto?
}
