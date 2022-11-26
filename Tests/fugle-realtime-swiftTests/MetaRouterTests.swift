import XCTest

final class MetaRouter {

    let symbolId: String

    let apiToken: String

    let scheme: String = "https"

    let host: String = "api.fugle.tw"

    let basePath: String = "/realtime/v0.3/intraday"

    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + "/meta"
        components.query = "symbolId=\(symbolId)&apiToken=\(apiToken)"
        return components.url!
    }

    init(symbolId: String, apiToken: String) {
        self.symbolId = symbolId
        self.apiToken = apiToken
    }
}

final class MetaRouterTests: XCTestCase {

    func testMetaRouter() throws {
        let sut = MetaRouter(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta?symbolId=5566&apiToken=taiwanNo1"))
    }
}
