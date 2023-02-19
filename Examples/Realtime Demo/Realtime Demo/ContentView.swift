import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    private let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)

    private let httpView: HTTPView = HTTPView(config: .demo)

    private let WwebSocketView: WebSocketView = WebSocketView(config: .demo)

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
