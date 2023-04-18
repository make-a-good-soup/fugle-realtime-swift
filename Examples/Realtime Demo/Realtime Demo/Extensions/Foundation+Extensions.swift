import Foundation

extension Double {
    var roundedString: String {
        String(format: "%.2f", self)
    }
}
