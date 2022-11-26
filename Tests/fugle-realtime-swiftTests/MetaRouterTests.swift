import XCTest

final class MetaRouter {

    let url: URL = URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta")!
}

final class MetaRouterTests: XCTestCase {

    func testMetaRouter() throws {
        let sut = MetaRouter()

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta"))
    }
}
