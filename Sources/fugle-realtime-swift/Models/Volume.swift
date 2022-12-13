//
//  Volumes.swift
//  
//
//  Created by Nick Chen on 2022/12/13.
//

import Foundation

struct Volume : Codable {
    let price: Double
    let volume: Double
    let volumeAtBid: Double
    let volumeAtAsk: Double
}

