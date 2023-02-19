import SwiftUI
import fugle_realtime_swift

private enum DataType: String, CaseIterable {
    case meta
    case quote
    case chart

    var title: String {
        switch (self) {
        case .meta: return "Meta"
        case .quote: return "Quote"
        case .chart: return "Chart"
        }
    }

    var buttonTitle: String { "Get \(title)" }
}

struct ContentView: View {
    private var symbolId: String { "2884" }

    private var apiToken: String { "demo" }

    @State var title: String = ""

    @State var jsonString: String = "Tap Button to print data"

    private let types = DataType.allCases
    
    var body: some View {
        TabView {
            VStack {
                Text(title)
                    .font(.title)
                    .frame(height: 50)
                ScrollView {
                    Text(jsonString)
                        .modifier(ConsoleLabel())
                }
                .modifier(ConsoleView())
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(DataType.allCases, id: \.rawValue) { type in
                            Button(type.buttonTitle) {
                                title = type.title
                                jsonString = "Loading..."
                                loadData(type: type)
                            }.modifier(LoadButton())
                        }
                    }.padding([.horizontal, .bottom])
                }
            }.tabItem {
                Label("HTTP", systemImage: "network")
            }

            Text("WebSocket").tabItem {
                Label("WebSocket", systemImage: "antenna.radiowaves.left.and.right")
            }
        }.accentColor(.teal)
    }

    private func loadData(type: DataType) {
        title = type.title
        Task {
            let model = await getModel(type: type)
            updateJSONString(model)
        }
    }

    private func getModel(type: DataType) async -> Encodable {
        switch type {
        case .meta:
            let result = await FugleHttpLoader().loadMeta(token: apiToken, symbolId: symbolId)
            return try? result.get()
        case .quote:
            let result = await FugleHttpLoader().loadQuote(token: apiToken, symbolId: symbolId)
            return try? result.get()
        case .chart:
            let result = await FugleHttpLoader().loadChart(token: apiToken, symbolId: symbolId)
            return try? result.get()
        }
    }

    private func updateJSONString(_ model: Encodable) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(model)
        if let data {
            jsonString = String(data: data, encoding: .utf8) ?? "Fail to load data."
        }
    }
}

private struct ConsoleLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding()
            .background(.black)
            .foregroundColor(.white)
    }
}

private struct ConsoleView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.black)
            .cornerRadius(10)
            .padding([.bottom, .horizontal])
    }
}

private struct LoadButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .frame(width: 120, height: 44)
            .background(.teal)
            .foregroundColor(.white)
            .cornerRadius(44)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
