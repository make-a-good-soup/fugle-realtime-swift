import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    private let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
    
    var body: some View {
        TabView {
            ZStack {
                gradient
                    .opacity(0.25)
                    .ignoresSafeArea()
                HTTPView()
            }.tabItem {
                Label("HTTP", systemImage: "network")
            }

            Text("WebSocket").tabItem {
                Label("WebSocket", systemImage: "antenna.radiowaves.left.and.right")
            }
        }.accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
