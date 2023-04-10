import Charts
import Foundation
import SwiftUI
import fugle_realtime_swift

@MainActor
class ChartViewModel: ObservableObject {

    @Published var fetchPhase = FetchPhase<ChartViewData>.initial
    var chart: ChartViewData? { fetchPhase.value }

    let apiService: StocksAPI

    var foregroundMarkColor: Color {
        chart?.lineColor ?? .cyan
    }

    private let dateFormatter = DateFormatter()

    // FIXME: 使用真實網址
    init(apiService: StocksAPI = WebSocketStream(url: URL(string: "www.google.com")!)) {
        self.apiService = apiService
    }

    func fetchData() async {
        do {
            fetchPhase = .fetching
            let chartData = try await apiService.fetchChartData()

            if let chartData {
                fetchPhase = .success(transformChartViewData(chartData))
            } else {
                fetchPhase = .empty
            }
        } catch {
            fetchPhase = .failure(error)
        }
    }

    private func transformChartViewData(_ data: ChartData) -> ChartViewData {
        let (xAxisChartData, items) = xAxisChartDataAndItems(data)
        let yAxisChartData = yAxisChartData(data)
        return ChartViewData(
            xAxisData: xAxisChartData,
            yAxisData: yAxisChartData,
            items: items,
            lineColor: getLineColor(data: data),
            previousCloseRuleMarkValue: previousCloseRuleMarkValue(data: data, yAxisData: yAxisChartData)
        )
    }

    // FIXME: 待修正 X 軸
    private func xAxisChartDataAndItems(_ data: ChartData) -> (ChartAxisData, [ChartViewItem]) {
        let timezone = TimeZone(secondsFromGMT: data.meta.gmtOffset) ?? .gmt
        dateFormatter.timeZone = timezone


        let map = [String: String]()
        var axisEnd: Int

        var items = [ChartViewItem]()

        for (_, value) in data.indicators.enumerated() {

            items.append(ChartViewItem(
                timestamp: value.timestamp,
                value: value.close))
        }
        axisEnd = items.count - 1

        let xAxisData = ChartAxisData(
            axisStart: 0,
            axisEnd: Double(max(0, axisEnd)),
            strideBy: 1,
            map: map)

        return (xAxisData, items)
    }

    private func yAxisChartData(_ data: ChartData) -> ChartAxisData {
        let closes = data.indicators.map { $0.close }
        var lowest = closes.min() ?? 0
        var highest = closes.max() ?? 0

        if let prevClose = data.meta.previousClose {
            if prevClose < lowest {
                lowest = prevClose
            } else if prevClose > highest {
                highest = prevClose
            }
        }
        // 2
        let diff = highest - lowest

        // 3
        let numberOfLines: Double = 4
        let shouldCeilIncrement: Bool
        let strideBy: Double

        if diff < (numberOfLines * 2) {
            // 4A
            shouldCeilIncrement = false
            strideBy = 0.01
        } else {
            // 4B
            shouldCeilIncrement = true
            lowest = floor(lowest)
            highest = ceil(highest)
            strideBy = 1.0
        }

        // 5
        let increment = ((highest - lowest) / (numberOfLines))
        var map = [String: String]()
        map[highest.roundedString] = formatYAxisValueLabel(value: highest, shouldCeilIncrement: shouldCeilIncrement)

        var current = lowest
        (0..<Int(numberOfLines) - 1).forEach { i in
            current += increment
            map[(shouldCeilIncrement ? ceil(current) : current).roundedString] = formatYAxisValueLabel(value: current, shouldCeilIncrement: shouldCeilIncrement)
        }

        return ChartAxisData(
            axisStart: lowest - 0.01,
            axisEnd: highest + 0.01,
            strideBy: strideBy,
            map: map)
    }

    private func formatYAxisValueLabel(value: Double, shouldCeilIncrement: Bool) -> String {
        if shouldCeilIncrement {
            return String(Int(ceil(value)))
        } else {
            return Utils.numberFormatter.string(from: NSNumber(value: value)) ?? value.roundedString
        }
    }

    private func previousCloseRuleMarkValue(data: ChartData, yAxisData: ChartAxisData) -> Double? {
        guard let previousClose = data.meta.previousClose else {
            return nil
        }
        return (yAxisData.axisStart <= previousClose && previousClose <= yAxisData.axisEnd) ? previousClose : nil
    }

    private func getLineColor(data: ChartData) -> Color {
        if let last = data.indicators.last?.close {
            if let prevClose = data.meta.previousClose {
                return last >= prevClose ? .green : .red
            } else if let first = data.indicators.first?.close {
                return last >= first ? .green : .red
            }
        }
        return .blue
    }
}
