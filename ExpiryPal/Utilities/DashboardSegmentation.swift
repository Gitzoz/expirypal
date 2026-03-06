import Foundation

enum DashboardSegment {
    case today
    case next3Days
    case later
}

enum DashboardSegmentation {
    static func segment(for expiryDate: Date, now: Date, calendar: Calendar) -> DashboardSegment {
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        let startOfDay4 = calendar.date(byAdding: .day, value: 4, to: startOfToday)!

        if expiryDate < startOfToday {
            return .today
        }

        if expiryDate < startOfTomorrow {
            return .today
        }

        if expiryDate < startOfDay4 {
            return .next3Days
        }

        return .later
    }
}
