import XCTest
import fugle_realtime_swift

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

final class IntradayRouterTests: XCTestCase {

    func testMeta() {
        let sut = IntradayRouter.meta(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta?symbolId=5566&apiToken=taiwanNo1"))
    }

    func testQuote() {
        let sut = IntradayRouter.quote(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/quote?symbolId=5566&apiToken=taiwanNo1"))
    }
}
