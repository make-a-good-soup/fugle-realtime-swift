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

    init(apiService: StocksAPI = WebSocketStream(url: WebSocketRouter.chart(parameters: ["symbolId": APIConfig.demo.symbolId, "apiToken": APIConfig.demo.apiToken]).url)) {
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

    private func xAxisChartDataAndItems(_ data: ChartData) -> (ChartAxisData, [ChartViewItem]) {
        let timezone = TimeZone(secondsFromGMT: data.meta.gmtOffset) ?? .gmt
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "H"

        var xAxisDateComponents = Set<DateComponents>()
        if let startTimestamp = data.indicators.first?.timestamp {
            xAxisDateComponents = getDateComponents(startDate: startTimestamp, endDate: data.meta.regularTradingPeriodEndDate, timezone: timezone)
        }


        var map = [String: String]()
        var axisEnd: Int

        var items = [ChartViewItem]()

        for (index, value) in data.indicators.enumerated() {
            let dc = value.timestamp.dateComponents(timeZone: timezone)
            if xAxisDateComponents.contains(dc) {
                map[String(index)] = dateFormatter.string(from: value.timestamp)
                xAxisDateComponents.remove(dc)
            }

            items.append(ChartViewItem(
                timestamp: value.timestamp,
                value: value.close))
        }
        axisEnd = items.count - 1

        if var date = items.last?.timestamp,
           date >= data.meta.regularTradingPeriodStartDate &&
            date < data.meta.regularTradingPeriodEndDate {
            while date < data.meta.regularTradingPeriodEndDate {
                axisEnd += 1
                date = Calendar.current.date(byAdding: .minute, value: 2, to: date)!
                let dc = date.dateComponents(timeZone: timezone)
                if xAxisDateComponents.contains(dc) {
                    map[String(axisEnd)] = dateFormatter.string(from: date)
                    xAxisDateComponents.remove(dc)
                }
            }
        }

        let xAxisData = ChartAxisData(
            axisStart: 0,
            axisEnd: Double(max(0, axisEnd)),
            strideBy: 1,
            map: map)

        return (xAxisData, items)
    }

    private func getDateComponents(startDate: Date, endDate: Date, timezone: TimeZone) -> Set<DateComponents> {
        let component: Calendar.Component = .hour
        let value: Int = 1

        var set  = Set<DateComponents>()
        var date = startDate

        while date <= endDate {
            date = Calendar.current.date(byAdding: component, value: value, to: date)!
            set.insert(date.dateComponents(timeZone: timezone))
        }
        return set
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
