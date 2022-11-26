import Foundation

public class FugleMetaLoader {

    public init() {}

    public func load(token: String, symbolId: String) async -> Result<Intraday<MetaData>, Error> {
        let url = IntradayRouter.meta(symbolId: symbolId, apiToken: token).url

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let meta = try JSONDecoder().decode(Intraday<MetaData>.self, from: data)
            return .success(meta)
        } catch {
            return .failure(error)
        }
    }
}
