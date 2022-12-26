import XCTest
import fugle_realtime_swift

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()

        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("foo", forHTTPHeaderField: "bar")
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "bar"), "foo")
            exp.fulfill()
        }

        makeSUT().perform(request: request) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()

        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError))

        XCTAssertNotNil(receivedError)
    }

    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        /*
         These cases should *never* happen, however as `URLSession` represents these fields as optional
         it is possible in some obscure way that this state _could_ exist.
         | Data?    | URLResponse?      | Error?   |
         |----------|-------------------|----------|
         | nil      | nil               | nil      |
         | nil      | URLResponse       | nil      |
         | value    | nil               | nil      |
         | value    | nil               | value    |
         | nil      | URLResponse       | value    |
         | nil      | HTTPURLResponse   | value    |
         | value    | URLResponse       | value    |
         | value    | HTTPURLResponse   | value    |
         | value    | URLResponse       | nil      |
         */

        XCTAssertNotNil(resultErrorFor((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let receivedValues = resultValuesFor((data: data, response: response, error: nil))

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()

        let receivedValues = resultValuesFor((data: nil, response: response, error: nil))

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(values, file: file, line: line)

        switch result {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = resultFor(values, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedResult: HTTPClient.Result!
        sut.perform(request: anyURLRequest()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }

    private func anyURLRequest() -> URLRequest {
        return URLRequest(url: anyURL())
    }

    private func anyNSError() -> NSError {
      return NSError(domain: "any error", code: 0)
    }

    private func anyData() -> Data {
        return Data("any data".utf8)
    }

    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
