import Foundation

public struct Intraday<T: Codable>: Codable {
    public let apiVersion: String
    public let data: T
}

public struct MetaData: Codable {
    public let info: Info
    public let meta: Meta
}

public struct ChartData: Codable {
    public let info: Info
    public let chart: Chart
}

public struct DealtsData: Codable {
    let info: Info
    let dealts: [Dealt]
}

public struct VolumesData: Codable {
    let info: Info
    let volumes: [Volume]
}
