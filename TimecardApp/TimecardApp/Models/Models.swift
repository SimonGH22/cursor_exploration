import Foundation

// MARK: - User Model
struct User: Identifiable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var role: String
    var status: UserStatus
    var avatarInitials: String {
        let first = firstName.prefix(1).uppercased()
        let last = lastName.prefix(1).uppercased()
        return "\(first)\(last)"
    }
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    var signatureImage: Data?
    
    static let sample = User(
        id: UUID(),
        firstName: "David",
        lastName: "Smith",
        email: "david.smith@company.com",
        phone: "+1 (555) 123-4567",
        role: "Foreman",
        status: .available
    )
}

enum UserStatus: String, CaseIterable {
    case available = "Available"
    case onSite = "On-Site"
    case onBreak = "On Break"
    case offDuty = "Off Duty"
    
    var color: String {
        switch self {
        case .available: return "statusGreen"
        case .onSite: return "statusBlue"
        case .onBreak: return "statusYellow"
        case .offDuty: return "statusRed"
        }
    }
}

// MARK: - Time Entry Model
struct TimeEntry: Identifiable {
    let id: UUID
    var date: Date
    var clockIn: Date
    var clockOut: Date?
    var breakDuration: TimeInterval
    var project: String
    var task: String
    var notes: String
    var status: EntryStatus
    
    var totalHours: Double {
        guard let clockOut = clockOut else { return 0 }
        let total = clockOut.timeIntervalSince(clockIn)
        return (total - breakDuration) / 3600
    }
    
    static let sample = TimeEntry(
        id: UUID(),
        date: Date(),
        clockIn: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
        clockOut: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()),
        breakDuration: 3600,
        project: "Highway Construction",
        task: "Equipment Operation",
        notes: "Completed morning shift",
        status: .submitted
    )
    
    static let samples: [TimeEntry] = [
        TimeEntry(
            id: UUID(),
            date: Date(),
            clockIn: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
            clockOut: Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()),
            breakDuration: 3600,
            project: "Highway Construction",
            task: "Equipment Operation",
            notes: "Completed full day",
            status: .approved
        ),
        TimeEntry(
            id: UUID(),
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            clockIn: Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!,
            clockOut: Calendar.current.date(bySettingHour: 16, minute: 30, second: 0, of: Date()),
            breakDuration: 1800,
            project: "Bridge Repair",
            task: "Inspection",
            notes: "Site inspection",
            status: .submitted
        ),
        TimeEntry(
            id: UUID(),
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            clockIn: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
            clockOut: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()),
            breakDuration: 3600,
            project: "Office Building",
            task: "Concrete Work",
            notes: "Foundation work",
            status: .pending
        )
    ]
}

enum EntryStatus: String, CaseIterable {
    case draft = "Draft"
    case pending = "Pending"
    case submitted = "Submitted"
    case approved = "Approved"
    case rejected = "Rejected"
    
    var color: String {
        switch self {
        case .draft: return "textSecondary"
        case .pending: return "statusYellow"
        case .submitted: return "statusBlue"
        case .approved: return "statusGreen"
        case .rejected: return "statusRed"
        }
    }
}

// MARK: - Summary Model
struct TimeSummary {
    var totalHours: Double
    var regularHours: Double
    var overtimeHours: Double
    var daysWorked: Int
    var pendingEntries: Int
    var approvedEntries: Int
    
    static let sample = TimeSummary(
        totalHours: 42.5,
        regularHours: 40.0,
        overtimeHours: 2.5,
        daysWorked: 5,
        pendingEntries: 2,
        approvedEntries: 3
    )
}

// MARK: - Menu Item Model
struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String?
    let hasChevron: Bool
    let action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String? = nil, hasChevron: Bool = true, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.hasChevron = hasChevron
        self.action = action
    }
}

// MARK: - Project Model
struct Project: Identifiable, Hashable {
    let id: UUID
    var name: String
    var code: String
    var location: String
    
    static let samples: [Project] = [
        Project(id: UUID(), name: "Highway Construction", code: "HC-001", location: "Interstate 95"),
        Project(id: UUID(), name: "Bridge Repair", code: "BR-042", location: "River Crossing"),
        Project(id: UUID(), name: "Office Building", code: "OB-103", location: "Downtown")
    ]
}

// MARK: - Notification Model
struct AppNotification: Identifiable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var isRead: Bool
    var type: NotificationType
    
    enum NotificationType {
        case approval
        case rejection
        case reminder
        case system
    }
    
    static let samples: [AppNotification] = [
        AppNotification(
            id: UUID(),
            title: "Timecard Approved",
            message: "Your timecard for Jan 20 has been approved.",
            date: Date(),
            isRead: false,
            type: .approval
        ),
        AppNotification(
            id: UUID(),
            title: "Reminder",
            message: "Don't forget to submit your weekly timecard.",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            isRead: true,
            type: .reminder
        )
    ]
}
