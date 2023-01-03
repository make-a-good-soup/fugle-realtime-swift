import Foundation

/// API Document: https://developer.fugle.tw/docs/data/intraday/overview

public enum WebSocketRouter {
    public typealias Parameters = [String: String]
    
    case meta(parameters: Parameters)
    case chart(parameters: Parameters)
    // case quote(parameters: Parameters)
}

extension WebSocketRouter: APIRouter {
    public var scheme: String { "wss" }
    
    public var parameters: [String : String]? {
        switch self {
        case let .meta(parameters):
            return parameters
        case let .chart(parameters):
            return parameters
        }
    }
    
    public var path: String {
        switch self {
        case .meta:
            return "/meta"
        case .chart:
            return "/chart"
        }
    }
}
