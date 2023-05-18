import Foundation

struct ChartResponse: Decodable {

    let data: [ChartData]?

    enum CodingKeys: CodingKey {
        case chart
    }

    enum ChartKeys: CodingKey {
        case result
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart) {
            data = try? chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
        } else {
            data = nil
        }
    }
}

struct ChartData: Decodable {

    let meta: ChartMeta
    let indicators: [Indicator]

    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }

    enum IndicatorsKeys: CodingKey {
        case quote
    }

    enum QuoteKeys: CodingKey {
        case high
        case close
        case low
        case open
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(ChartMeta.self, forKey: .meta)

        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {


            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []

            indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard
                    let open = opens[offset],
                    let low = lows[offset],
                    let close = closes[offset],
                    let high = highs[offset]
                else { return nil}
                return .init(timestamp: timestamp, open: open, high: high, low: low, close: close)
            }
        } else {
            self.indicators = []
        }
    }

    init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }
}

struct ChartMeta: Decodable {
    let currency: String
    let symbol: String
    let regularMarketPrice: Double?
    let previousClose: Double?
    let gmtOffset: Int
    let regularTradingPeriodStartDate: Date
    let regularTradingPeriodEndDate: Date

    enum CodingKeys: CodingKey {
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtoffset
        case currentTradingPeriod
    }

    enum CurrentTradingPeriodKeys: String, CodingKey {
        case pre
        case regular
        case post
    }

    enum TradingPeriodKeys: String, CodingKey {
        case start
        case end
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        self.gmtOffset = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0

        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingPeriodKeys.self, forKey: .currentTradingPeriod)
        let regularTradingPeriodContainer = try? currentTradingPeriodContainer?.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regular)
        self.regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .start) ?? Date()
        self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .end) ?? Date()
    }

    public init(currency: String, symbol: String, regularMarketPrice: Double? = nil, previousClose: Double? = nil, gmtOffset: Int, regularTradingPeriodStartDate: Date, regularTradingPeriodEndDate: Date) {
        self.currency = currency
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.previousClose = previousClose
        self.gmtOffset = gmtOffset
        self.regularTradingPeriodStartDate = regularTradingPeriodStartDate
        self.regularTradingPeriodEndDate = regularTradingPeriodEndDate
    }
}

struct Indicator: Decodable {
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
}
