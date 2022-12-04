import Foundation

public struct Intraday<T: Codable>: Codable {
    let apiVersion: String
    let data: T
}

public struct MetaData: Codable {
    let info: Info
    let meta: Meta
}

public struct ChartData: Codable {
    let info: Info
    let chart: Chart
}
