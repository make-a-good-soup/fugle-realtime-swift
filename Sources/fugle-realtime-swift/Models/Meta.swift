import Foundation

public struct Meta: Codable {
    public let market: String
    public let nameZhTw: String
    public let industryZhTw: String?
    public let priceReference: Double
    public let priceHighLimit: Double
    public let priceLowLimit: Double
    public let canDayBuySell: Bool
    public let canDaySellBuy: Bool
    public let canShortMargin: Bool?
    public let canShortLend: Bool?
    public let tradingUnit: Int
    public let currency: String?
    public let isTerminated: Bool
    public let isSuspended: Bool
    public let typeZhTw: String
    public let abnormal: String
    public let isUnusuallyRecommended: Bool?
}
