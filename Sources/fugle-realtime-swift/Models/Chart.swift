import Foundation

struct Chart : Codable {
    let a : [Double]? // 當日個股於此分鐘的成交均價
    let o : [Double]? // 此分鐘的開盤價
    let h : [Double]? // 此分鐘的最高價
    let l : [Double]? // 此分鐘的最低價
    let c : [Double]? // 此分鐘的收盤價
    let v : [Double]? // 此分鐘的成交量 (指數：金額；個股：張數；興櫃股票及零股：股數)
    let t : [Double]? // Unix timestamp (每分鐘單位)
}
