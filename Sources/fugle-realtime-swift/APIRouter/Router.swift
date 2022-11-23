//
//  File.swift
//  
//
//  Created by Nick Chen on 2022/11/23.
//

import Foundation

enum Router : APIRouter {    
    case Meta(token: String, symbolId: String)
    case Quote(token: String, symbolId: String)
    
    var path: String {
        switch(self) {
        case .Meta: return "/meta"
        case .Quote: return "/quote"
        }
    }
    
    var parameters: [String : String]? {
        switch(self) {
        case .Meta: return ["token": "", "symbolId": ""] // TODO: 將 enum constructor parameter 代入
        case .Quote: return ["token": "", "symbolId": ""] // TODO: 將 enum constructor parameter 代入
        }
    }
}
