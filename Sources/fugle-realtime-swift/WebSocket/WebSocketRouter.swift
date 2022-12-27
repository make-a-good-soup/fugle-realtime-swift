import Foundation

/// API Document: https://developer.fugle.tw/docs/data/intraday/overview

public enum WebSocketRouter {
    public typealias Parameters = [String: String]

    case meta(parameters: Parameters)
    // TODO: add new cases
    // case chart(parameters: Parameters)
    // case quote(parameters: Parameters)
}

extension WebSocketRouter: APIRouter {
    public var scheme: String { "wss" }

    public var parameters: [String : String]? {
        switch self {
        case let .meta(parameters):
            return parameters
        }
    }

    public var path: String {
        switch self {
        case .meta:
            return "/meta"
        }
    }
}
