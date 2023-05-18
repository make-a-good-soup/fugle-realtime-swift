import Foundation

struct Utils {

    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static func format(value: Double?) -> String? {
        guard let value,
              let text = numberFormatter.string(from: NSNumber(value: value))
        else { return nil }
        return text
    }

}

