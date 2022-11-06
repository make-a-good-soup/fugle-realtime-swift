import Foundation

struct Meta: Codable {
    let market: String
    let nameZhTw: String
    let industryZhTw: String
    let priceReference: Double
    let priceHighLimit: Double
    let priceLowLimit: Double
    let canDayBuySell: Bool
    let canDaySellBuy: Bool
    let canShortMargin: Bool
    let canShortLend: Bool
    let tradingUnit: Int
    let currency: String
    let isTerminated: Bool
    let isSuspended: Bool
    let typeZhTw: String
    let abnormal: String
    let isUnusuallyRecommended: Bool
}
