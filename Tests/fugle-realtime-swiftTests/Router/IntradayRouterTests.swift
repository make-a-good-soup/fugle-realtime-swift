import XCTest
import fugle_realtime_swift

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
