import Foundation

public struct Chart : Codable {
    public let averagePrices : [Double]? // 當日個股於此分鐘的成交均價
    public let openingPrices : [Double]? // 此分鐘的開盤價
    public let highestPrices : [Double]? // 此分鐘的最高價
    public let lowestPrices : [Double]? // 此分鐘的最低價
    public let closingPrices : [Double]? // 此分鐘的收盤價
    public let volumes : [Double]? // 此分鐘的成交量 (指數：金額；個股：張數；興櫃股票及零股：股數)
    public let times : [Double]? // Unix timestamp (每分鐘單位)
    
    enum CodingKeys: String, CodingKey {
        case averagePrices = "a"
        case openingPrices = "o"
        case highestPrices = "h"
        case lowestPrices = "l"
        case closingPrices = "c"
        case volumes = "v"
        case times = "t"
    }
}
