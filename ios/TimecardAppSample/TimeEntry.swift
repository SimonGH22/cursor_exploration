import Foundation

struct TimeEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var employee: String
    var date: Date
    var startMinutes: Int
    var endMinutes: Int
    var breakMinutes: Int
    var project: String
    var notes: String

    init(
        id: UUID = UUID(),
        employee: String,
        date: Date,
        startMinutes: Int,
        endMinutes: Int,
        breakMinutes: Int,
        project: String,
        notes: String
    ) {
        self.id = id
        self.employee = employee
        self.date = date
        self.startMinutes = startMinutes
        self.endMinutes = endMinutes
        self.breakMinutes = breakMinutes
        self.project = project
        self.notes = notes
    }

    var shiftMinutes: Int {
        max(0, endMinutes - startMinutes - breakMinutes)
    }

    var hours: Double {
        Double(shiftMinutes) / 60.0
    }

    var dateLabel: String {
        TimeUtils.formattedDate(date)
    }

    var shiftLabel: String {
        let start = TimeUtils.formattedTime(minutes: startMinutes)
        let end = TimeUtils.formattedTime(minutes: endMinutes)
        return "\(start) - \(end)"
    }

    var sortKey: Date {
        TimeUtils.date(from: date, minutes: startMinutes)
    }
}

enum TimeUtils {
    static let calendar = Calendar.current

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let hoursFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static func minutes(from date: Date) -> Int {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0) * 60 + (components.minute ?? 0)
    }

    static func startOfDay(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func date(from day: Date, minutes: Int) -> Date {
        let bounded = max(0, min(minutes, 24 * 60 - 1))
        let hour = bounded / 60
        let minute = bounded % 60
        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: startOfDay(for: day)
        ) ?? day
    }

    static func formattedDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    static func formattedTime(minutes: Int) -> String {
        timeFormatter.string(from: date(from: Date(), minutes: minutes))
    }

    static func formattedHours(_ hours: Double) -> String {
        hoursFormatter.string(from: NSNumber(value: hours)) ?? String(format: "%.2f", hours)
    }

    static func defaultStartTime() -> Date {
        date(from: Date(), minutes: 9 * 60)
    }

    static func defaultEndTime() -> Date {
        date(from: Date(), minutes: 17 * 60)
    }
}
