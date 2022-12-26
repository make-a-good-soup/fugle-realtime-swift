import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func perform(request: URLRequest, completion: @escaping (Result) -> Void)
}
