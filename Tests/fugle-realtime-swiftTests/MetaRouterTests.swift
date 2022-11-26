import XCTest
import fugle_realtime_swift

final class MetaRouterTests: XCTestCase {

    func testMetaRouter() throws {
        let sut = MetaRouter(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta?symbolId=5566&apiToken=taiwanNo1"))
    }
}
