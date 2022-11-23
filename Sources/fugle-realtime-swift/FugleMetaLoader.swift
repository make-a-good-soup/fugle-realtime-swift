import Foundation

public class FugleMetaLoader {

    public init() {}
    
    func load(router: Router) async -> Result<Intraday<MetaData>, Error> {
        // TODO: 待處理
        return Error()
    }

    public func load(token: String, symbolId: String) async -> Result<Intraday<MetaData>, Error> {
        var urlComponents = URLComponents()
        urlComponents.host = "api.fugle.tw"
        urlComponents.scheme = "https"
        urlComponents.path = "/realtime/v0.3/intraday/meta"
        urlComponents.query = "symbolId=\(symbolId)&apiToken=\(token)"
        let url = urlComponents.url!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let meta = try JSONDecoder().decode(Intraday<MetaData>.self, from: data)
            return .success(meta)
        } catch {
            return .failure(error)
        }
    }
}
