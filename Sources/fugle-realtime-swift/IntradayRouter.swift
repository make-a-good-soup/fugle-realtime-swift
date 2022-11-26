import Foundation

public enum IntradayRouter {
    case meta(symbolId: String, apiToken: String)
    case quote(symbolId: String, apiToken: String)
}

extension IntradayRouter: APIRouter {
    public var parameters: [String : String]? {
        switch self {
        case let .meta(symbolId, apiToken),
            let .quote(symbolId, apiToken):
            return ["symbolId": symbolId, "apiToken": apiToken]
        }
    }

    public var path: String {
        switch self {
        case .meta:
            return "/meta"
        case .quote:
            return "/quote"
        }
    }
}
