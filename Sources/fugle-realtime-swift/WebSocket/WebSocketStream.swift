import Foundation

public class WebSocketStream {
    public typealias Element = URLSessionWebSocketTask.Message
    public typealias AsyncIterator = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator

    private var stream: AsyncThrowingStream<Element, Error>?
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?
    private let socket: URLSessionWebSocketTask

    public init(url: URL, session: URLSession = URLSession.shared) {
        socket = session.webSocketTask(with: url)
        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket.cancel()
            }
        }
    }
}

extension WebSocketStream: AsyncSequence {
    public func makeAsyncIterator() -> AsyncIterator {
        guard let stream else {
            fatalError("stream was not initialized")
        }
        socket.resume()
        listenForMessages()
        return stream.makeAsyncIterator()
    }

    private func listenForMessages() {
        socket.receive { [unowned self] result in
            switch result {
            case let .success(message):
                continuation?.yield(message)
                listenForMessages()
            case let .failure(error):
                continuation?.finish(throwing: error)
            }
        }
    }
}
