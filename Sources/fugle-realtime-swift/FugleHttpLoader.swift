import Foundation

public class FugleHttpLoader {
    
    public init() {}
    
    public func loadMeta(token: String, symbolId: String) async -> Result<Intraday<MetaData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token]
        let url = IntradayRouter.meta(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let meta = try JSONDecoder().decode(Intraday<MetaData>.self, from: data)
            return .success(meta)
        } catch {
            return .failure(error)
        }
    }
    
    public func loadChart(token: String, symbolId: String) async -> Result<Intraday<ChartData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token]
        let url = IntradayRouter.chart(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("data: \(data)")
            let chart = try JSONDecoder().decode(Intraday<ChartData>.self, from: data)
            return .success(chart)
        } catch {
            return .failure(error)
        }
    }
}
