import Foundation

public protocol APIRouter {
    var scheme: String { get }
    var host: String { get }
    var basePath: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var url: URL { get }
}

extension APIRouter {
    public var scheme: String { "https" }

    public var host: String  { "api.fugle.tw" }

    public var basePath: String { "/realtime/v0.3/intraday" }

    public var url: URL {
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
