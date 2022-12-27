import Foundation

/// API Document: https://developer.fugle.tw/docs/data/intraday/overview

public enum IntradayRouter {
    public typealias Parameters = [String: String]
    
    case meta(parameters: Parameters)
    case quote(parameters: Parameters)
    case chart(parameters: Parameters)
    case dealts(parameters: Parameters)
    case volumes(parameters: Parameters)
}

extension IntradayRouter: APIRouter {
    public var parameters: [String : String]? {
        switch self {
        case let .meta(parameters),
            let .quote(parameters),
            let .chart(parameters),
            let .dealts(parameters),
            let .volumes(parameters):
            return parameters
        }
    }
    
    public var path: String {
        switch self {
        case .meta:
            return "/meta"
        case .quote:
            return "/quote"
        case .chart:
            return "/chart"
        case .dealts:
            return "/dealts"
        case .volumes:
            return "/volumes"
        }
    }
}
