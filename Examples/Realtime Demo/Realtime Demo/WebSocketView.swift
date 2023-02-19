import SwiftUI
import fugle_realtime_swift

struct WebSocketView: View {
    private var symbolId: String { "2884" }

    private var apiToken: String { "demo" }

    @State var stockName: String = "stockName"
    @State var stockPrice: Double = 0.0
    
    var body: some View {
        VStack {
            Text(stockName)
                .font(.title)
                .padding()
            Text(String(stockPrice))
                .font(.title)
                .padding()
        }.task {
            let parameters = ["symbolId": symbolId, "apiToken": apiToken]
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

struct WebSocketView_Previews: PreviewProvider {
    static var previews: some View {
        WebSocketView()
    }
}
