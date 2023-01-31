import Foundation

public class FugleHttpLoader {
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }
    
    public func loadMeta(token: String, symbolId: String) async -> Result<Intraday<MetaData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token]
        let url = IntradayRouter.meta(parameters: parameters).url
        
        let result = await httpClient.perform(url: url)
        
        switch result {
        case let .success((data, _)):
            do {
                let meta = try JSONDecoder().decode(Intraday<MetaData>.self, from: data)
                return .success(meta)
            } catch {
                return .failure(error)
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    /// 提供盤中個股/指數逐筆交易金額、狀態、最佳五檔及統計資訊
    ///
    /// - Parameters:
    ///     - token: realtime api token
    ///     - symbolId: 個股、指數識別代碼
    ///     - oddLot: 設置 true 回傳零股行情。預設值：false
    ///
    public func loadQuote(token: String, symbolId: String, oddLot: Bool = false) async -> Result<Intraday<QuoteData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token, "oddLot": String(oddLot)]
        let url = IntradayRouter.quote(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let quote = try JSONDecoder().decode(Intraday<QuoteData>.self, from: data)
            return .success(quote)
        } catch {
            return .failure(error)
        }
    }
    
    public func loadChart(token: String, symbolId: String) async -> Result<Intraday<ChartData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token]
        let url = IntradayRouter.chart(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let chart = try JSONDecoder().decode(Intraday<ChartData>.self, from: data)
            return .success(chart)
        } catch {
            return .failure(error)
        }
    }
    
    /// 取得個股當日所有成交資訊（ex: 個股價量、大盤總量）
    ///
    /// - Parameters:
    ///     - token: realtime api token
    ///     - symbolId: 個股、指數識別代碼
    ///     - limit: 限制最多回傳的資料筆數。預設值：50
    ///     - offset: 指定從第幾筆後開始回傳。預設值：0
    ///     - oddLot: 設置 true 回傳零股行情。預設值：false
    ///
    public func loadDealts(token: String, symbolId: String, limit: Int = 50, offset: Int = 0, oddLot: Bool = false) async -> Result<Intraday<DealtsData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token, "limit": String(limit), "offset": String(offset), "oddLot": String(oddLot)]
        let url = IntradayRouter.dealts(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let dealts = try JSONDecoder().decode(Intraday<DealtsData>.self, from: data)
            return .success(dealts)
        } catch {
            return .failure(error)
        }
    }
    
    /// 提供盤中個股即時分價量
    ///
    /// - Parameters:
    ///     - token: realtime api token
    ///     - symbolId: 個股、指數識別代碼
    ///     - oddLot: 設置 true 回傳零股行情。預設值：false
    ///
    public func loadVolumes(token: String, symbolId: String, oddLot: Bool = false) async -> Result<Intraday<VolumesData>, Error> {
        let parameters = ["symbolId": symbolId, "apiToken": token, "oddLot": String(oddLot)]
        let url = IntradayRouter.volumes(parameters: parameters).url
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let volumes = try JSONDecoder().decode(Intraday<VolumesData>.self, from: data)
            return .success(volumes)
        } catch {
            return .failure(error)
        }
    }
}
