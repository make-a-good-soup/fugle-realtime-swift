//
//  File.swift
//  
//
//  Created by Nick Chen on 2022/12/13.
//

import Foundation

struct Dealt : Codable {
    let at: String // 此筆交易的成交時間
    let bid: Double? // 此筆交易的買進價
    let ask: Double? // 此筆交易的賣出價
    let price: Double // 此筆交易的成交價
    let volume: Double // 此筆交易的成交量
    let serial: Double // 此筆交易的序號
}
