//
//  File.swift
//  
//
//  Created by Nick Chen on 2022/12/25.
//

import Foundation

struct Quote: Codable {
    let isCurbing: Bool? // 最近一次更新是否為瞬間價格穩定措施
    let isCurbingFall: Bool? // 最近一次更新是否為暫緩撮合且瞬間趨跌
    let isCurbingRise: Bool? // 最近一次更新是否為暫緩撮合且瞬間趨漲
    let tradingCurb: TradingCurb? // 最近一次更新瞬間價格趨勢
    let isTrial: Bool? // 最近一次更新是否為試算
    let isOpenDelayed: Bool? // 最近一次更新是否為延後開盤狀態
    let isCloseDelayed: Bool? // 最近一次更新是否為延後收盤狀態
    let isHalting: Bool? // 最近一次更新是否為暫停交易
    let isClosed: Bool? // 當日是否為已收盤
    let isDealt: Bool? // 最近一次更新是否包含最新成交(試撮)價
    let total: Total?
    let trial: Trial?
    let trade: Trade?
    let order: Order?
    let priceHigh: Price? // 當日之最高價
    let priceLow: Price? // 當日之最低價
    let priceOpen: Price? // 當日之開盤價
    let priceAvg: Price? // 當日之成交均價(當日最後一筆成交時間)
    let sbl: Sbl? // 借券賣出可用餘額
    let change: Double? // 當日股價之漲跌
    let changePercent: Double? // 當日股價之漲跌幅
    let amplitude: Double? // 當日股價之振幅
    let priceLimit: Double? // 0 = 正常；1 = 跌停；2 = 漲停
}

struct Order: Codable {
    let at: String // 最新一筆最佳五檔更新時間
    let bids: [BidAsk]
    let asks: [BidAsk]
}

struct BidAsk: Codable {
    let price: Double
    let volume: Double
}

struct Price: Codable {
    let price: Double
    let at: String
}

struct Sbl: Codable {
    let availableVolume: Double // 借券賣出可用餘額(股)
    let at: String
}

struct Total: Codable {
    let at: String // 最新一筆成交時間
    let transaction: Double // 總成交筆數
    let tradeValue: Double // 總成交金額
    let tradeVolume: Double // 總成交數量
    let tradeVolumeAtBid: Double // 個股內盤成交量
    let tradeVolumeAtAsk: Double // 個股外盤成交量
    let bidOrders: Double? // 總委買筆數 (僅加權、櫃買指數)
    let askOrders: Double? // 總委賣筆數 (僅加權、櫃買指數)
    let bidVolume: Double? // 總委買數量 (僅加權、櫃買指數
    let askVolume: Double? // 總委賣數量 (僅加權、櫃買指數)
    let serial: Double // 最新一筆成交之序號
}

struct Trade: Codable {
    let at: String // 最新一筆試撮時間
    let bid: Double? // 最新一筆試撮買進價
    let ask: Double? // 最新一筆試撮賣出價
    let price: Double? // 最新一筆試撮成交價
    let volume: Double? // 最新一筆試撮成交量
    let serial: String? // 最新一筆成交之序號
}

struct Trial: Codable {
    let at: String // 最新一筆試撮時間
    let bid: Double? // 最新一筆試撮買進價
    let ask: Double? // 最新一筆試撮賣出價
    let price: Double? // 最新一筆試撮成交價
    let volume: Double? // 最新一筆試撮成交量
}

struct TradingCurb: Codable {
    let priceLimit: Double? // 0 = 正常；1 = 趨跌；2 = 趨漲
    let isCurbed: Bool // 是否進入瞬間價格穩定措施
    let at: String // 進入瞬間價格穩定措施或恢復逐筆交易時間
}

