//
//  ContentView.swift
//  Realtime Demo
//
//  Created by 洪德晟 on 2022/11/1.
//

import SwiftUI
import fugle_realtime_swift

struct ContentView: View {
    var body: some View {
        Button("Hello, world!") {
            Task {
                await RealTimeTestForDemo.fire()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
