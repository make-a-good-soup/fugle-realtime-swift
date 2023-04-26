import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func perform(url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await session.data(from: url)
            if let response = response as? HTTPURLResponse {
                return Result.success((data, response))
            } else {
                return Result.failure(UnexpectedValuesRepresentation())
            }
        } catch {
            return Result.failure(error)
        }
    }
}
