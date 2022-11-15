import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    var body: some View {
        Button("Hello, world!") {
            Task {
                let result = await FugleMetaLoader().load(token: "", symbolId: "2330")
                let model = try? result.get()
                if let model {
                    print(model)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
