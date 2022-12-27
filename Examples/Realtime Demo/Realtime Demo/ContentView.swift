import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    private var apiToken: String { "demo" }

    @State var stockName: String = "stockName"
    @State var stockPrice: Double = 0.0
    
    var body: some View {
        VStack {
            Button("Hello, world!") {
                Task {
                    let result = await FugleHttpLoader().loadMeta(token: apiToken, symbolId: "2884")
                    let model = try? result.get()
                    if let model {
                        print(model)
                    }
                }

            }.padding(8)
            Text(stockName)
                .font(.system(size: 24))
                .padding(8)
            Text("$\(String(stockPrice))")
                .font(.system(size: 18))
                .padding(8)
        }.task {
            let parameters = ["symbolId": "2884", "apiToken": apiToken]
            let stream = WebSocketStream(url: WebSocketRouter.meta(parameters: parameters).url)

            do {
                for try await message in stream {
                    let meta = try message.meta()
                    stockName = meta.data.meta.nameZhTw
                    stockPrice = meta.data.meta.priceReference
                }
            } catch {
                debugPrint("Oops something didn't go right")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
