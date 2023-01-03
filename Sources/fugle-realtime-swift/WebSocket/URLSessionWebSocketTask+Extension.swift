import Foundation

enum WebSocketError: Error {
    case invalidFormat
}

extension URLSessionWebSocketTask.Message {
    public func meta() throws -> Intraday<MetaData> {
        switch self {
        case .string(let json):
            guard let data = json.data(using: .utf8) else {
                throw WebSocketError.invalidFormat
            }
            
            return try JSONDecoder().decode(Intraday<MetaData>.self, from: data)
            
        case .data:
            throw WebSocketError.invalidFormat
            
        @unknown default:
            throw WebSocketError.invalidFormat
        }
    }
    
    public func chart() throws -> Intraday<ChartData> {
        switch self {
        case .string(let json):
            guard let data = json.data(using: .utf8) else {
                throw WebSocketError.invalidFormat
            }
            
            return try JSONDecoder().decode(Intraday<ChartData>.self, from: data)
            
        case .data:
            throw WebSocketError.invalidFormat
            
        @unknown default:
            throw WebSocketError.invalidFormat
        }
    }
    
    // TODO: 新增 quote 的資料解析
}
