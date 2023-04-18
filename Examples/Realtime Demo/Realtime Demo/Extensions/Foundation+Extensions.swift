import Foundation

extension Double {
    var roundedString: String {
        String(format: "%.2f", self)
    }
}

extension Date {

    func dateComponents(timeZone: TimeZone, calendar: Calendar = .current) -> DateComponents {
        let current = calendar.dateComponents(in: timeZone, from: self)

        var dc = DateComponents(timeZone: timeZone, year: current.year, month: current.month)
        dc.hour = current.hour

        return dc
    }

}
