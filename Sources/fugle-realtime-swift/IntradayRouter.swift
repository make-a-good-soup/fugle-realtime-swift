import Foundation

/// API Document: https://developer.fugle.tw/docs/data/intraday/overview

public enum IntradayRouter {
    case meta(symbolId: String, apiToken: String)
    case quote(symbolId: String, apiToken: String)
// TODO: add new cases
//    case chart
//    case dealts
//    case volumes
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
