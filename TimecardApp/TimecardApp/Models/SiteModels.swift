import Foundation

// MARK: - Site Model
struct Site: Identifiable {
    let id: UUID
    var name: String
    var location: String
    var shiftDetails: ShiftDetails
    var siteRules: [SiteRule]
    var workingDays: [DayOfWeek]
    var holidays: [Holiday]
    
    static let sample = Site(
        id: UUID(),
        name: "Highway Construction",
        location: "Interstate 95",
        shiftDetails: ShiftDetails(
            shiftType: .regular,
            startTime: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
        ),
        siteRules: SiteRule.samples,
        workingDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
        holidays: Holiday.samples
    )
}

// MARK: - Shift Details
struct ShiftDetails {
    var shiftType: ShiftType
    var startTime: Date
    var endTime: Date
    
    enum ShiftType: String, CaseIterable {
        case regular = "Regular"
        case night = "Night"
        case split = "Split"
        case flexible = "Flexible"
    }
}

// MARK: - Site Rule
struct SiteRule: Identifiable {
    let id: UUID
    var title: String
    var description: String
    
    static let samples: [SiteRule] = [
        SiteRule(
            id: UUID(),
            title: "Personal Protective Equipment (PPE)",
            description: "Mandating the use of appropriate PPE is a fundamental rule."
        ),
        SiteRule(
            id: UUID(),
            title: "Worksite Tidiness",
            description: "Keeping the construction site clean."
        ),
        SiteRule(
            id: UUID(),
            title: "Safety Protocols",
            description: "Following all safety guidelines and emergency procedures."
        )
    ]
}

// MARK: - Day of Week
enum DayOfWeek: String, CaseIterable, Identifiable {
    case sunday = "S"
    case monday = "M"
    case tuesday = "T"
    case wednesday = "W"
    case thursday = "T"
    case friday = "F"
    case saturday = "S"
    
    var id: String { self.rawValue + String(self.index) }
    
    var fullName: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
    
    var index: Int {
        switch self {
        case .sunday: return 0
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        }
    }
    
    static var orderedDays: [DayOfWeek] {
        [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }
}

// MARK: - Holiday
struct Holiday: Identifiable {
    let id: UUID
    var name: String
    var date: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    static let samples: [Holiday] = [
        Holiday(id: UUID(), name: "New Year's Day", date: createDate(year: 2025, month: 1, day: 1)),
        Holiday(id: UUID(), name: "Republic Day", date: createDate(year: 2025, month: 1, day: 26)),
        Holiday(id: UUID(), name: "Independence Day", date: createDate(year: 2025, month: 8, day: 15)),
        Holiday(id: UUID(), name: "Gandhi Jayanti", date: createDate(year: 2025, month: 10, day: 2))
    ]
    
    private static func createDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
}
