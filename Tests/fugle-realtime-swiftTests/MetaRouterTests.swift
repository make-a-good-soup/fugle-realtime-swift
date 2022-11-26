import XCTest

final class MetaRouter {

    let scheme: String = "https"

    let host: String = "api.fugle.tw"

    let basePath: String = "/realtime/v0.3/intraday"

    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + "/meta"
        return components.url!
    }
}

final class MetaRouterTests: XCTestCase {

    func testMetaRouter() throws {
        let sut = MetaRouter()

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta"))
    }
}
