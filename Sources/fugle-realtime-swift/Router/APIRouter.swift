import Foundation

public protocol APIRouter {
    var scheme: String { get }
    var host: String { get }
    var basePath: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var url: URL { get }
}

public extension APIRouter {
    var scheme: String { "https" }

    var host: String { "api.fugle.tw" }

    var basePath: String { "/realtime/v0.3/intraday" }

    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + path

        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return components.url!
    }
}
