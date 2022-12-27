import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func perform(url: URL) async -> HTTPClient.Result
}
