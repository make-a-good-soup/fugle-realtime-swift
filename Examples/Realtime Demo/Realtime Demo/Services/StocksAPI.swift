import Foundation
import fugle_realtime_swift

protocol StocksAPI {
    func fetchChartData() async throws -> ChartData?
}

extension WebSocketStream: StocksAPI {
    func fetchChartData() async throws -> ChartData? {
        var data: ChartData?
        for try await message in self {
            let chart = try message.chart()
            let info = chart.data.info

            let start = chart.data.chart.times?.first

            guard let start else  { return nil }

            data = ChartData(meta: ChartMeta(currency: info.exchange,
                                             symbol: info.symbolId,
                                             gmtOffset: 28800,
                                             regularTradingPeriodStartDate: Date(timeIntervalSince1970: start/1000),
                                             regularTradingPeriodEndDate: Date(timeIntervalSince1970: (start/1000)+16140)
                                            ),
                             indicators: chart.data.chart.toIndicators()
            )

            return data
        }

        return data
    }
}

extension fugle_realtime_swift.Chart {

    func toIndicators() -> [Indicator] {
        var result: [Indicator] = []

        guard let averagePrices,
              let times,
              let openingPrices,
              let highestPrices,
              let lowestPrices,
              let closingPrices
        else { return result }

        guard checkArrayLengthsEqual([averagePrices,
                                      times,
                                      openingPrices,
                                      highestPrices,
                                      lowestPrices,
                                      closingPrices])
        else { return result }

        for (index, _) in averagePrices.enumerated() {
            result.append(Indicator(timestamp: Date(timeIntervalSince1970: times[index]/1000),
                                    open: openingPrices[index],
                                    high: highestPrices[index],
                                    low: lowestPrices[index],
                                    close: closingPrices[index]
                                   )
            )
        }

        return result
    }
}

func checkArrayLengthsEqual(_ arrays: [[Any]]) -> Bool {
    return arrays.allSatisfy { $0.count == arrays.first?.count }
}
