import Foundation

public struct Info: Codable {
    public let date: String
    public let type: String
    public let exchange: String
    public let market: String
    public let symbolId: String
    public let countryCode: String
    public let timeZone: String
    public let lastUpdatedAt: String?
}
