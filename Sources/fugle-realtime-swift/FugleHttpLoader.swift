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
}
