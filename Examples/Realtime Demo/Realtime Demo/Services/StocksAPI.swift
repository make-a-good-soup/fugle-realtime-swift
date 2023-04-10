import Foundation
import fugle_realtime_swift

protocol StocksAPI {
    func fetchChartData() async throws -> ChartData?
}

extension WebSocketStream: StocksAPI {
    // TODO: 待實作
    func fetchChartData() async throws -> ChartData? {
        nil
    }
}
