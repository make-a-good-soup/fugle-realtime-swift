import XCTest
import fugle_realtime_swift

final class IntradayRouterTests: XCTestCase {
    private let parameters = ["key" : "value"]
    
    func testMeta() {
        let sut = IntradayRouter.meta(parameters: parameters)
        
        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/meta?key=value"))
    }
    
    func testQuote() {
        let sut = IntradayRouter.quote(parameters: parameters)
        
        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/quote?key=value"))
    }
    
    func testChart() {
        let sut = IntradayRouter.chart(parameters: parameters)
        
        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/chart?key=value"))
    }
    
    func testDealts() {
        let sut = IntradayRouter.dealts(parameters: parameters)
        
        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/dealts?key=value"))
    }
    
    func testVolumes() {
        let sut = IntradayRouter.volumes(parameters: parameters)
        
        XCTAssertEqual(sut.url, URL(string: "https://api.fugle.tw/realtime/v0.3/intraday/volumes?key=value"))
    }
}
