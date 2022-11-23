//
//  File.swift
//  
//
//  Created by Nick Chen on 2022/11/23.
//

import Foundation

public protocol APIRouter {
    var scheme: String { get }
    var host: String { get }
    var basePath: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var url: URL { get }
}

extension APIRouter {
    public var scheme: String {
        return "https"
    }
    
    public var host: String {
        return "api.fugle.tw"
    }
    
    public var basePath: String {
        return "/realtime/v0.3"
    }
    
    public var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = basePath + path
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url!
    }
}
