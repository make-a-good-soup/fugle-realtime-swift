import fugle_realtime_swift
import XCTest

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()

        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_failsOnRequestError() async {
        let requestError = anyNSError()

        let receivedError = await resultErrorFor((data: nil, response: nil, error: requestError))

        XCTAssertNotNil(receivedError)
    }

    // FIXME: 測試會有未知的錯誤，待調整
    //    func test_getFromURL_failsOnAllInvalidRepresentationCases() async {
    //        /*
    //         These cases should *never* happen, however as `URLSession` represents these fields as optional
    //         it is possible in some obscure way that this state _could_ exist.
    //         | Data?    | URLResponse?      | Error?   |
    //         |----------|-------------------|----------|
    //         | nil      | nil               | nil      |
    //         | nil      | URLResponse       | nil      |
    //         | value    | nil               | nil      |
    //         | value    | nil               | value    |
    //         | nil      | URLResponse       | value    |
    //         | nil      | HTTPURLResponse   | value    |
    //         | value    | URLResponse       | value    |
    //         | value    | HTTPURLResponse   | value    |
    //         | value    | URLResponse       | nil      |
    //         */
    //
    //        let result1 = await resultErrorFor((data: nil, response: nil, error: nil))
    //        XCTAssertNotNil(result1)
    //
    //        let result2 = await resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil))
    //        XCTAssertNotNil(result2)
    //
    //        let result3 = await resultErrorFor((data: anyData(), response: nil, error: nil))
    //        XCTAssertNotNil(result3)
    //
    //        let result4 = await resultErrorFor((data: anyData(), response: nil, error: anyNSError()))
    //        XCTAssertNotNil(result4)
    //
    //        let resul5 = await resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
    //        XCTAssertNotNil(resul5)
    //
    //        let result6 = await resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
    //        XCTAssertNotNil(result6)
    //
    //        let result7 = await resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
    //        XCTAssertNotNil(result7)
    //
    //        let result8 = await resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
    //        XCTAssertNotNil(result8)
    //
    //        let result9 = await resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil))
    //        XCTAssertNotNil(result9)
    //    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let receivedValues = await resultValuesFor((data: data, response: response, error: nil))

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() async {
        let response = anyHTTPURLResponse()

        let receivedValues = await resultValuesFor((data: nil, response: response, error: nil))

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

    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) async -> (data: Data, response: HTTPURLResponse)? {
        let result = await resultFor(values, file: file, line: line)

        switch result {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, file: StaticString = #filePath, line: UInt = #line) async -> Error? {
        let result = await resultFor(values, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, file: StaticString = #filePath, line: UInt = #line) async -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }

        let sut = makeSUT(file: file, line: line)

        let receivedResult = await sut.perform(url: anyURL())
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
