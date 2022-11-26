import XCTest
import fugle_realtime_swift

final class QuoteRouterTests: XCTestCase {

    func testQuoteRoute() throws {
        let sut = QuoteRouter(symbolId: "5566", apiToken: "taiwanNo1")

        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/quote?symbolId=5566&apiToken=taiwanNo1"))
    }
}
