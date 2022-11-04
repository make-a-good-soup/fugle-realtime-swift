import Foundation

public struct RealTimeTestForDemo {
    public private(set) var text = "Hello, World!"

    public init() {}

    public static func fire() async {
        let urlRequest = URLRequest(url: URL(string: "https://www.fugle.tw/.well-known/apple-app-site-association")!)
        let data = try? await URLSession.shared.data(for: urlRequest)
        print(data as Any)
    }
}
