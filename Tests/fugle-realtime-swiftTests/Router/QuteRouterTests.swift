import XCTest
import fugle_realtime_swift

public final class QuoteRouter {

    public let symbolId: String

    public let apiToken: String

    public let scheme: String = "https"

    public let host: String = "api.fugle.tw"

    public let basePath: String = "/realtime/v0.3/intraday"

    public var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + "/quote"
        components.query = "symbolId=\(symbolId)&apiToken=\(apiToken)"
        return components.url!
    }

    public init(symbolId: String, apiToken: String) {
        self.symbolId = symbolId
        self.apiToken = apiToken
    }
}

final class QuoteRouterTests: XCTestCase {

    func testQuoteRoute() throws {
        let sut = QuoteRouter(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/quote?symbolId=5566&apiToken=taiwanNo1"))
    }
}
