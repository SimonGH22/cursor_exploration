import SwiftUI
import UIKit

enum RootTab: Hashable {
    case home
    case logs
    case more
    case account
}

struct RootView: View {
    @StateObject private var store = TimeEntryStore()
    @AppStorage("timecard.isLoggedIn") private var isLoggedIn = false
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else if !isLoggedIn {
                LoginView(isLoggedIn: $isLoggedIn)
            } else {
                MainTabView(store: store, isLoggedIn: $isLoggedIn)
            }
        }
    }
}

struct SplashView: View {
    @Binding var isActive: Bool

    private let steps = [
        "Syncing configuration",
        "Checking device integrity",
        "Requesting permissions"
    ]

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "clock.badge.checkmark")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(AppTheme.accent)

                    Text("TimeCard")
                        .font(.title)
                        .foregroundColor(AppTheme.textPrimary)

                    Text("Preparing your workspace")
                        .foregroundColor(AppTheme.textSecondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(steps, id: \.self) { step in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppTheme.accent)
                            Text(step)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, 24)

                ProgressView()
                    .tint(AppTheme.accent)

                Spacer()
            }
            .padding(.bottom, 24)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                withAnimation(.easeInOut) {
                    isActive = false
                }
            }
        }
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var companyCode = ""
    @State private var rememberDevice = true
    @State private var statusMessage = ""
    @State private var statusIsError = false

    var body: some View {
        AuthContainer {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("Sign in to track time and manage logs.")
                        .foregroundColor(AppTheme.textSecondary)
                }

                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        InputField(
                            title: "Email",
                            placeholder: "name@company.com",
                            text: $email,
                            keyboard: .emailAddress
                        )
                        InputField(
                            title: "Password",
                            placeholder: "Enter password",
                            text: $password,
                            isSecure: true
                        )
                        InputField(
                            title: "Company code",
                            placeholder: "LNR-001",
                            text: $companyCode
                        )

                        Toggle("Remember this device", isOn: $rememberDevice)
                            .tint(AppTheme.accent)
                    }
                }

                Button("Sign In") {
                    attemptLogin()
                }
                .buttonStyle(PrimaryActionButtonStyle())

                Button("Forgot password?") {}
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(AppTheme.accent)

                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundColor(statusIsError ? AppTheme.destructive : AppTheme.textSecondary)
                }

                Spacer(minLength: 16)
            }
        }
    }

    private func attemptLogin() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCompany = companyCode.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty,
              !trimmedPassword.isEmpty,
              !trimmedCompany.isEmpty else {
            statusMessage = "Enter email, password, and company code."
            statusIsError = true
            return
        }

        statusMessage = "Signed in."
        statusIsError = false
        isLoggedIn = true
    }
}

struct MainTabView: View {
    @ObservedObject var store: TimeEntryStore
    @Binding var isLoggedIn: Bool
    @State private var selectedTab: RootTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            TimeTrackingView(store: store, selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "clock") }
                .tag(RootTab.home)

            LogsView(store: store)
                .tabItem { Label("Logs", systemImage: "list.bullet.rectangle") }
                .tag(RootTab.logs)

            MoreView()
                .tabItem { Label("More", systemImage: "ellipsis.circle") }
                .tag(RootTab.more)

            AccountView(isLoggedIn: $isLoggedIn)
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
                .tag(RootTab.account)
        }
        .tint(AppTheme.accent)
    }
}

struct TimeTrackingView: View {
    @ObservedObject var store: TimeEntryStore
    @Binding var selectedTab: RootTab

    @State private var employeeName = "Diana Stone"
    @State private var selectedProject = "Warehouse Expansion"
    @State private var taskRecord = ""
    @State private var breakMinutes = 15
    @State private var autoClockOutEnabled = true
    @State private var autoClockOutHours = 8
    @State private var isClockedIn = false
    @State private var clockInDate = Date()
    @State private var elapsedSeconds = 0
    @State private var statusMessage = ""
    @State private var statusIsError = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let projectOptions = [
        "Warehouse Expansion",
        "Concrete Pour",
        "Mechanical Rough-In",
        "Finish Work",
        "General Labor"
    ]

    var body: some View {
        ScreenContainer(title: "Time Tracking") {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Stopwatch")
                            .font(.headline)
                        Spacer()
                        StatusPill(
                            label: isClockedIn ? "Clocked In" : "Off Shift",
                            color: isClockedIn ? AppTheme.accent : AppTheme.pill
                        )
                    }

                    Text(timerLabel)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)

                    Text(clockStatusLabel)
                        .foregroundColor(AppTheme.textSecondary)

                    HStack(spacing: 12) {
                        Button("Clock In") {
                            clockIn()
                        }
                        .buttonStyle(PrimaryActionButtonStyle())
                        .disabled(isClockedIn)

                        Button("Clock Out") {
                            clockOut(auto: false)
                        }
                        .buttonStyle(SecondaryPillButtonStyle(isDestructive: true))
                        .disabled(!isClockedIn)
                    }
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Assignment")
                        .font(.headline)

                    VStack(spacing: 0) {
                        FormRow(title: "Crew member") {
                            TextField("Crew member", text: $employeeName)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(AppTheme.textPrimary)
                        }

                        AppDivider()

                        FormRow(title: "Project") {
                            Picker("", selection: $selectedProject) {
                                ForEach(projectOptions, id: \.self) { project in
                                    Text(project).tag(project)
                                }
                            }
                            .labelsHidden()
                            .tint(AppTheme.accent)
                        }

                        AppDivider()

                        FormRow(title: "Task record") {
                            TextField("Laying out pillars", text: $taskRecord)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                    }
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Clocking")
                        .font(.headline)

                    VStack(spacing: 0) {
                        FormRow(title: "Break minutes") {
                            HStack(spacing: 8) {
                                Text("\(breakMinutes)m")
                                    .foregroundColor(AppTheme.textPrimary)
                                Stepper("", value: $breakMinutes, in: 0...180, step: 5)
                                    .labelsHidden()
                                    .tint(AppTheme.accent)
                            }
                        }

                        AppDivider()

                        FormRow(title: "Auto clock-out") {
                            Toggle("", isOn: $autoClockOutEnabled)
                                .labelsHidden()
                                .tint(AppTheme.accent)
                        }

                        if autoClockOutEnabled {
                            AppDivider()

                            FormRow(title: "Auto after") {
                                Stepper(
                                    "\(autoClockOutHours)h",
                                    value: $autoClockOutHours,
                                    in: 4...14
                                )
                                .labelsHidden()
                                .tint(AppTheme.accent)
                            }
                        }
                    }
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Management")
                        .font(.headline)

                    Text("Edit or correct time entries before payroll approval.")
                        .foregroundColor(AppTheme.textSecondary)

                    Button("Edit Logs") {
                        selectedTab = .logs
                    }
                    .buttonStyle(SecondaryPillButtonStyle())
                }
            }

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundColor(statusIsError ? AppTheme.destructive : AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onReceive(timer) { _ in
            guard isClockedIn else { return }
            elapsedSeconds = max(0, Int(Date().timeIntervalSince(clockInDate)))

            if autoClockOutEnabled,
               elapsedSeconds >= autoClockOutHours * 3600 {
                clockOut(auto: true)
            }
        }
    }

    private var timerLabel: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private var clockStatusLabel: String {
        if isClockedIn {
            let startMinutes = TimeUtils.minutes(from: clockInDate)
            return "Clocked in at \(TimeUtils.formattedTime(minutes: startMinutes))"
        }
        return "Ready to clock in."
    }

    private func clockIn() {
        clockInDate = Date()
        elapsedSeconds = 0
        isClockedIn = true
        statusMessage = "Clocked in."
        statusIsError = false
    }

    private func clockOut(auto: Bool) {
        guard isClockedIn else { return }
        isClockedIn = false

        let startMinutes = TimeUtils.minutes(from: clockInDate)
        var endMinutes = TimeUtils.minutes(from: Date())
        if endMinutes <= startMinutes {
            endMinutes = min(startMinutes + 1, 24 * 60 - 1)
        }

        let shiftLength = endMinutes - startMinutes
        let safeBreak = min(breakMinutes, max(0, shiftLength - 1))

        let entry = TimeEntry(
            employee: employeeName,
            date: TimeUtils.startOfDay(for: clockInDate),
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            breakMinutes: safeBreak,
            project: selectedProject,
            notes: taskRecord.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        store.add(entry)
        elapsedSeconds = 0
        taskRecord = ""

        statusMessage = auto ? "Auto clock-out saved log entry." : "Clocked out and saved log."
        statusIsError = false
    }
}

struct LogsView: View {
    @ObservedObject var store: TimeEntryStore
    @State private var editingEntry: TimeEntry?
    @State private var statusMessage = ""

    private let calendar = Calendar.current

    var body: some View {
        ScreenContainer(title: "Logs") {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Log Actions")
                        .font(.headline)

                    Text("View current logs and complete history.")
                        .foregroundColor(AppTheme.textSecondary)

                    HStack(spacing: 12) {
                        Button("Add sample data") {
                            store.addSampleEntries()
                            statusMessage = "Sample logs added."
                        }
                        .buttonStyle(SecondaryPillButtonStyle())

                        Button("Export CSV") {
                            UIPasteboard.general.string = store.exportCSV()
                            statusMessage = "CSV copied to clipboard."
                        }
                        .buttonStyle(SecondaryPillButtonStyle())
                    }
                }
            }

            LogSectionCard(
                title: "Today",
                entries: store.entries.filter { calendar.isDateInToday($0.date) },
                onEdit: { editingEntry = $0 },
                onDelete: { store.remove($0) }
            )

            LogSectionCard(
                title: "History",
                entries: store.entries.filter { !calendar.isDateInToday($0.date) },
                onEdit: { editingEntry = $0 },
                onDelete: { store.remove($0) }
            )

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .sheet(item: $editingEntry) { entry in
            LogEditView(store: store, entry: entry)
        }
    }
}

struct LogSectionCard: View {
    let title: String
    let entries: [TimeEntry]
    let onEdit: (TimeEntry) -> Void
    let onDelete: (TimeEntry) -> Void

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)

                if entries.isEmpty {
                    Text("No logs available.")
                        .foregroundColor(AppTheme.textSecondary)
                } else {
                    ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                        LogRow(entry: entry, onEdit: { onEdit(entry) }, onDelete: { onDelete(entry) })

                        if index < entries.count - 1 {
                            AppDivider()
                        }
                    }
                }
            }
        }
    }
}

struct LogRow: View {
    let entry: TimeEntry
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.dateLabel)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                    Text(entry.employee)
                        .font(.headline)
                }

                Spacer()

                Text(TimeUtils.formattedHours(entry.hours))
                    .font(.headline)
            }

            Text(entry.shiftLabel)
                .foregroundColor(AppTheme.textSecondary)

            if !entry.project.isEmpty {
                Text("Project: \(entry.project)")
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
            }

            if !entry.notes.isEmpty {
                Text("Task: \(entry.notes)")
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
            }

            HStack(spacing: 10) {
                ActionChip(title: "Edit", color: AppTheme.accent, action: onEdit)
                ActionChip(title: "Delete", color: AppTheme.destructive, action: onDelete)
            }
        }
    }
}

struct LogEditView: View {
    @ObservedObject var store: TimeEntryStore
    let entry: TimeEntry
    @Environment(\.dismiss) private var dismiss

    @State private var employee: String
    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var breakMinutes: Int
    @State private var project: String
    @State private var notes: String
    @State private var statusMessage = ""

    init(store: TimeEntryStore, entry: TimeEntry) {
        self.store = store
        self.entry = entry
        _employee = State(initialValue: entry.employee)
        _date = State(initialValue: entry.date)
        _startTime = State(initialValue: TimeUtils.date(from: entry.date, minutes: entry.startMinutes))
        _endTime = State(initialValue: TimeUtils.date(from: entry.date, minutes: entry.endMinutes))
        _breakMinutes = State(initialValue: entry.breakMinutes)
        _project = State(initialValue: entry.project)
        _notes = State(initialValue: entry.notes)
    }

    var body: some View {
        ModalContainer(title: "Edit Log", onClose: { dismiss() }) {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Correct time entry")
                        .font(.headline)

                    VStack(spacing: 0) {
                        FormRow(title: "Crew member") {
                            TextField("Crew member", text: $employee)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(AppTheme.textPrimary)
                        }

                        AppDivider()

                        FormRow(title: "Date") {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                                .tint(AppTheme.accent)
                        }

                        AppDivider()

                        FormRow(title: "Start time") {
                            DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(AppTheme.accent)
                        }

                        AppDivider()

                        FormRow(title: "End time") {
                            DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .tint(AppTheme.accent)
                        }

                        AppDivider()

                        FormRow(title: "Break minutes") {
                            HStack(spacing: 8) {
                                Text("\(breakMinutes)m")
                                    .foregroundColor(AppTheme.textPrimary)
                                Stepper("", value: $breakMinutes, in: 0...180, step: 5)
                                    .labelsHidden()
                                    .tint(AppTheme.accent)
                            }
                        }

                        AppDivider()

                        FormRow(title: "Project") {
                            TextField("Project", text: $project)
                                .textFieldStyle(.plain)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Task record")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        TextEditor(text: $notes)
                            .frame(minHeight: 80)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(AppTheme.formField)
                            .foregroundColor(AppTheme.textPrimary)
                            .tint(AppTheme.accent)
                            .cornerRadius(12)
                    }
                }
            }

            Button("Save changes") {
                saveChanges()
            }
            .buttonStyle(PrimaryActionButtonStyle())

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundColor(AppTheme.destructive)
            }
        }
    }

    private func saveChanges() {
        let trimmedEmployee = employee.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmployee.isEmpty else {
            statusMessage = "Crew member is required."
            return
        }

        let startMinutes = TimeUtils.minutes(from: startTime)
        let endMinutes = TimeUtils.minutes(from: endTime)
        guard endMinutes > startMinutes else {
            statusMessage = "End time must be after start time."
            return
        }

        let shiftLength = endMinutes - startMinutes
        let safeBreak = min(breakMinutes, max(0, shiftLength - 1))

        let updated = TimeEntry(
            id: entry.id,
            employee: trimmedEmployee,
            date: date,
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            breakMinutes: safeBreak,
            project: project.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        store.update(updated)
        dismiss()
    }
}

struct MoreView: View {
    private let operations = [
        FeatureItem(
            title: "Licenses",
            subtitle: "Manage app or operating licenses.",
            systemImage: "doc.text"
        ),
        FeatureItem(
            title: "Leaves & Approvals",
            subtitle: "Request time off and review approvals.",
            systemImage: "checkmark.seal"
        ),
        FeatureItem(
            title: "Collaboration",
            subtitle: "Team communication and shared tasks.",
            systemImage: "person.2.fill"
        ),
        FeatureItem(
            title: "Payroll",
            subtitle: "Review payroll-ready timecards.",
            systemImage: "banknote"
        ),
        FeatureItem(
            title: "Daily Field Report (DFR)",
            subtitle: "Upload or download daily field images.",
            systemImage: "photo.on.rectangle"
        ),
        FeatureItem(
            title: "Report Incident",
            subtitle: "Safety reporting for the field.",
            systemImage: "exclamationmark.triangle"
        )
    ]

    private let services = [
        ServiceItem(title: "Crash Monitor", detail: "Firebase Crashlytics"),
        ServiceItem(title: "Analytics", detail: "Event tracking plan"),
        ServiceItem(title: "Notifications", detail: "Firebase actionable alerts"),
        ServiceItem(title: "Realtime Update", detail: "Socket or notification sync"),
        ServiceItem(title: "Logging", detail: "Napier + Firebase errors"),
        ServiceItem(title: "Design System", detail: "Unified components")
    ]

    var body: some View {
        ScreenContainer(title: "More") {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Operations & Reporting")
                        .font(.headline)

                    ForEach(Array(operations.enumerated()), id: \.offset) { index, item in
                        FeatureRow(item: item)
                        if index < operations.count - 1 {
                            AppDivider()
                        }
                    }
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Services & Integrations")
                        .font(.headline)

                    ForEach(Array(services.enumerated()), id: \.offset) { index, item in
                        ServiceRow(item: item)
                        if index < services.count - 1 {
                            AppDivider()
                        }
                    }
                }
            }
        }
    }
}

struct AccountView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        ScreenContainer(title: "Account") {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile picture")
                        .font(.headline)

                    HStack(spacing: 12) {
                        Circle()
                            .fill(AppTheme.formField)
                            .frame(width: 64, height: 64)
                            .overlay(
                                Text("DS")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textPrimary)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Diana Stone")
                                .font(.headline)
                            Text("Foreman")
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }

                    HStack(spacing: 12) {
                        Button("View / Zoom") {}
                            .buttonStyle(OutlineButtonStyle())
                        Button("Add Photo") {}
                            .buttonStyle(OutlineButtonStyle())
                    }

                    HStack(spacing: 12) {
                        Button("Camera") {}
                            .buttonStyle(OutlineButtonStyle())
                        Button("Library") {}
                            .buttonStyle(OutlineButtonStyle())
                    }

                    Text("Uploads support crop before saving.")
                        .font(.footnote)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            Card {
                VStack(spacing: 0) {
                    ProfileRow(label: "User ID", value: "cfe987033")
                    AppDivider()
                    ProfileRow(label: "Email", value: "diana.lane@email.com")
                    AppDivider()
                    ProfileRow(label: "Phone", value: "+1 602-539-4782")
                    AppDivider()
                    ProfileRow(label: "Company", value: "Ultra Inc")
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Support & Security")
                        .font(.headline)

                    AccountActionRow(
                        title: "Help & Support",
                        subtitle: "FAQs and contact options"
                    )
                    AppDivider()
                    AccountActionRow(
                        title: "About",
                        subtitle: "App info and version"
                    )
                    AppDivider()
                    AccountActionRow(
                        title: "Reset Password",
                        subtitle: "Update your credentials"
                    )
                }
            }

            Button("Log out") {
                isLoggedIn = false
            }
            .buttonStyle(SecondaryPillButtonStyle(isDestructive: true))
        }
    }
}

struct AuthContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    content()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct ModalContainer<Content: View>: View {
    let title: String
    let onClose: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button("Close") {
                            onClose()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.accent)

                        Spacer()

                        Text(title)
                            .font(.headline)

                        Spacer()
                        Text(" ")
                            .frame(width: 44)
                    }
                    .padding(.top, 8)

                    content()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(10)
                    .background(AppTheme.formField)
                    .cornerRadius(10)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(10)
                    .background(AppTheme.formField)
                    .cornerRadius(10)
            }
        }
    }
}

struct StatusPill: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .foregroundColor(AppTheme.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .cornerRadius(999)
    }
}

struct ActionChip: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .font(.caption.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.16))
            .cornerRadius(999)
    }
}

struct FeatureItem {
    let title: String
    let subtitle: String
    let systemImage: String
}

struct FeatureRow: View {
    let item: FeatureItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.systemImage)
                .foregroundColor(AppTheme.accent)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.vertical, 6)
    }
}

struct ServiceItem {
    let title: String
    let detail: String
}

struct ServiceRow: View {
    let item: ServiceItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                Text(item.detail)
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.vertical, 6)
    }
}

struct AccountActionRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.vertical, 6)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(AppTheme.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(AppTheme.accentSoft)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .stroke(AppTheme.accent.opacity(0.4), lineWidth: 1)
            )
            .cornerRadius(999)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
