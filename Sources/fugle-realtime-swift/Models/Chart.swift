import Foundation

struct Chart : Codable {
    let averagePrices : [Double]? // 當日個股於此分鐘的成交均價
    let openingPrices : [Double]? // 此分鐘的開盤價
    let highestPrices : [Double]? // 此分鐘的最高價
    let lowestPrices : [Double]? // 此分鐘的最低價
    let closingPrices : [Double]? // 此分鐘的收盤價
    let volumes : [Double]? // 此分鐘的成交量 (指數：金額；個股：張數；興櫃股票及零股：股數)
    let times : [Double]? // Unix timestamp (每分鐘單位)
    
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
