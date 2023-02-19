import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    private let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
    private var symbolId: String { "2884" }

    private var apiToken: String { "demo" }

    private var httpView: HTTPView { HTTPView(symbolId: symbolId, apiToken: apiToken) }

    private var WwebSocketView: WebSocketView { WebSocketView(symbolId: symbolId, apiToken: apiToken) }

    var body: some View {
        TabView {
            ZStack {
                gradient
                    .opacity(0.25)
                    .ignoresSafeArea()
                httpView
            }.tabItem {
                Label("HTTP", systemImage: "network")
            }

            WwebSocketView.tabItem {
                Label("WebSocket", systemImage: "antenna.radiowaves.left.and.right")
            }
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
