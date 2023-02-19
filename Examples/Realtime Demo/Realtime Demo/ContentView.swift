import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    
    var body: some View {
        TabView {
            HTTPView().tabItem {
                Label("HTTP", systemImage: "network")
            }

            Text("WebSocket").tabItem {
                Label("WebSocket", systemImage: "antenna.radiowaves.left.and.right")
            }
        }.accentColor(.teal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
