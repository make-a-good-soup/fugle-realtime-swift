import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    private let gradient = LinearGradient(colors: [.orange, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)

    private let httpView: HTTPView = HTTPView(config: .demo)

    @StateObject var vm = ChartViewModel()

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

            VStack {
                if let chartViewData = vm.chart {
                    Text(APIConfig.demo.symbolId)
                    ChartView(data: chartViewData, vm: vm).padding()
                }
            }
            .tabItem {
                Label("WebSocket", systemImage: "antenna.radiowaves.left.and.right")
            }.task { await vm.fetchData() }
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
