import Foundation

public struct Intraday<T: Codable>: Codable {
    public let apiVersion: String
    public let data: T
}

public struct MetaData: Codable {
    public let info: Info
    public let meta: Meta
}

public struct QuoteData: Codable {
    let info: Info
    let quote: Quote
}

public struct ChartData: Codable {
    let info: Info
    let chart: Chart
}

public struct DealtsData: Codable {
    let info: Info
    let dealts: [Dealt]
}

public struct VolumesData: Codable {
    let info: Info
    let volumes: [Volume]
}
