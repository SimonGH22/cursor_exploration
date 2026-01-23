import SwiftUI
import UIKit

enum AppTab: Hashable {
    case timecard
    case entries
    case summary
    case profile
}

enum AppTheme {
    static let background = Color(red: 0.06, green: 0.07, blue: 0.10)
    static let card = Color(red: 0.13, green: 0.15, blue: 0.20)
    static let cardBorder = Color.white.opacity(0.08)
    static let formField = Color(red: 0.17, green: 0.19, blue: 0.25)
    static let pill = Color(red: 0.18, green: 0.21, blue: 0.28)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.68)
    static let accent = Color(red: 0.18, green: 0.49, blue: 0.95)
    static let accentSoft = Color(red: 0.18, green: 0.49, blue: 0.95).opacity(0.2)
    static let destructive = Color(red: 0.95, green: 0.36, blue: 0.40)
    static let divider = Color.white.opacity(0.08)
}

struct ContentView: View {
    @StateObject private var store = TimeEntryStore()
    @State private var selectedTab: AppTab = .timecard

    var body: some View {
        TabView(selection: $selectedTab) {
            TimecardHomeView(store: store, selectedTab: $selectedTab)
                .tabItem { Label("Timecard", systemImage: "clock") }
                .tag(AppTab.timecard)

            EntriesView(store: store)
                .tabItem { Label("Entries", systemImage: "list.bullet.rectangle") }
                .tag(AppTab.entries)

            SummaryView(store: store)
                .tabItem { Label("Summary", systemImage: "chart.bar") }
                .tag(AppTab.summary)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(AppTab.profile)
        }
        .tint(AppTheme.accent)
    }
}

struct TimecardHomeView: View {
    @ObservedObject var store: TimeEntryStore
    @Binding var selectedTab: AppTab

    @State private var employee = ""
    @State private var date = Date()
    @State private var startTime = TimeUtils.defaultStartTime()
    @State private var endTime = TimeUtils.defaultEndTime()
    @State private var breakMinutes = 30
    @State private var project = ""
    @State private var notes = ""
    @State private var statusMessage = ""
    @State private var statusIsError = false
    @State private var showingClearConfirm = false

    var body: some View {
        ScreenContainer(title: "My Timecard") {
            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Time entry details")
                        .font(.headline)

                    VStack(spacing: 0) {
                        FormRow(title: "Employee name *") {
                            TextField("Alex Morgan", text: $employee)
                                .textInputAutocapitalization(.words)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        AppDivider()

                        FormRow(title: "Date *") {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .tint(AppTheme.accent)
                        }
                        AppDivider()

                        FormRow(title: "Start time *") {
                            DatePicker(
                                "",
                                selection: $startTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .tint(AppTheme.accent)
                        }
                        AppDivider()

                        FormRow(title: "End time *") {
                            DatePicker(
                                "",
                                selection: $endTime,
                                displayedComponents: .hourAndMinute
                            )
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

                        FormRow(title: "Project or role") {
                            TextField("Fulfillment lead", text: $project)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                    }
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes")
                        .font(.headline)

                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Optional details about the shift")
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.top, 10)
                                .padding(.leading, 14)
                        }

                        TextEditor(text: $notes)
                            .frame(minHeight: 90)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(AppTheme.formField)
                            .foregroundColor(AppTheme.textPrimary)
                            .tint(AppTheme.accent)
                            .cornerRadius(12)
                    }
                }
            }

            Button("Add entry", action: addEntry)
                .buttonStyle(PrimaryActionButtonStyle())

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                Button("Add sample data") {
                    store.addSampleEntries()
                    setStatus("Sample data added.", isError: false)
                }
                .buttonStyle(SecondaryPillButtonStyle())

                Button("Copy CSV") {
                    copyCSV()
                }
                .buttonStyle(SecondaryPillButtonStyle())

                Button("Clear all") {
                    showingClearConfirm = true
                }
                .buttonStyle(SecondaryPillButtonStyle(isDestructive: true))
            }

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.footnote)
                    .foregroundColor(statusIsError ? AppTheme.destructive : AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            SummaryPanel(store: store)

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Recent entries")
                            .font(.headline)
                        Spacer()
                        Button("View all") {
                            selectedTab = .entries
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.accent)
                    }

                    let recentEntries = Array(store.entries.prefix(3))
                    if recentEntries.isEmpty {
                        Text("No time entries yet.")
                            .foregroundColor(AppTheme.textSecondary)
                    } else {
                        ForEach(Array(recentEntries.enumerated()), id: \.element.id) { index, entry in
                            EntryCompactRow(entry: entry)
                            if index < recentEntries.count - 1 {
                                AppDivider()
                            }
                        }
                    }
                }
            }
        }
        .confirmationDialog(
            "Clear all entries?",
            isPresented: $showingClearConfirm,
            titleVisibility: .visible
        ) {
            Button("Clear all", role: .destructive) {
                store.clear()
                setStatus("All entries cleared.", isError: false)
            }
        }
    }

    private func addEntry() {
        let trimmedEmployee = employee.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProject = project.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmployee.isEmpty else {
            setStatus("Employee name is required.", isError: true)
            return
        }

        let startMinutes = TimeUtils.minutes(from: startTime)
        let endMinutes = TimeUtils.minutes(from: endTime)
        let shiftLength = endMinutes - startMinutes

        guard shiftLength > 0 else {
            setStatus("End time must be after start time.", isError: true)
            return
        }

        guard breakMinutes >= 0 && breakMinutes < shiftLength else {
            setStatus("Break must be shorter than the shift.", isError: true)
            return
        }

        let entry = TimeEntry(
            employee: trimmedEmployee,
            date: date,
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            breakMinutes: breakMinutes,
            project: trimmedProject,
            notes: trimmedNotes
        )

        store.add(entry)
        project = ""
        notes = ""
        setStatus("Entry added.", isError: false)
    }

    private func copyCSV() {
        let csv = store.exportCSV()
        UIPasteboard.general.string = csv
        setStatus("CSV copied to clipboard.", isError: false)
    }

    private func setStatus(_ message: String, isError: Bool) {
        statusMessage = message
        statusIsError = isError
    }
}

struct EntriesView: View {
    @ObservedObject var store: TimeEntryStore

    var body: some View {
        ScreenContainer(title: "Entries") {
            if store.entries.isEmpty {
                Card {
                    Text("No time entries yet. Add one from the Timecard tab.")
                        .foregroundColor(AppTheme.textSecondary)
                }
            } else {
                ForEach(store.entries) { entry in
                    EntryCard(entry: entry) {
                        store.remove(entry)
                    }
                }
            }
        }
    }
}

struct SummaryView: View {
    @ObservedObject var store: TimeEntryStore

    var body: some View {
        ScreenContainer(title: "Summary") {
            SummaryPanel(store: store)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ScreenContainer(title: "My Profile") {
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
                    Text("Signature")
                        .font(.headline)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.cardBorder, lineWidth: 1)
                            .frame(height: 140)

                        Text("Diana Stone")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .foregroundColor(AppTheme.accent)
                    }

                    Button("Clear signature") {}
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(AppTheme.accent)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct ScreenContainer<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    AppHeader(title: title)
                    content()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .foregroundColor(AppTheme.textPrimary)
            }
        }
    }
}

struct AppHeader: View {
    let title: String

    var body: some View {
        ZStack {
            Text(title)
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)

            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppTheme.accent)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.headline)
                }
                .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(.top, 8)
    }
}

struct Card<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.card)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 8)
    }
}

struct FormRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            content()
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.vertical, 10)
    }
}

struct SummaryPanel: View {
    @ObservedObject var store: TimeEntryStore

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Summary")
                    .font(.headline)

                HStack(spacing: 12) {
                    StatPill(label: "Entries", value: "\(store.entries.count)")
                    StatPill(label: "Total hours", value: TimeUtils.formattedHours(store.totalHours))
                    StatPill(label: "Overtime", value: TimeUtils.formattedHours(store.overtimeHours))
                }

                AppDivider()

                Text("Hours by employee")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)

                let totals = store.employeeTotals()
                if totals.isEmpty {
                    Text("No employee totals yet.")
                        .foregroundColor(AppTheme.textSecondary)
                } else {
                    ForEach(Array(totals.enumerated()), id: \.element.name) { index, item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(TimeUtils.formattedHours(item.hours))
                                .foregroundColor(AppTheme.textSecondary)
                        }

                        if index < totals.count - 1 {
                            AppDivider()
                        }
                    }
                }
            }
        }
    }
}

struct EntryCard: View {
    let entry: TimeEntry
    var onDelete: (() -> Void)?

    var body: some View {
        Card {
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

                    if let onDelete = onDelete {
                        Button(role: .destructive, action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .foregroundColor(AppTheme.destructive)
                    }
                }

                Text("\(entry.shiftLabel) | Break \(entry.breakMinutes)m")
                    .foregroundColor(AppTheme.textSecondary)

                Text("Hours: \(TimeUtils.formattedHours(entry.hours))")
                    .font(.subheadline)

                if !entry.project.isEmpty {
                    Text("Project: \(entry.project)")
                        .font(.footnote)
                        .foregroundColor(AppTheme.textSecondary)
                }

                if !entry.notes.isEmpty {
                    Text("Notes: \(entry.notes)")
                        .font(.footnote)
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
        }
    }
}

struct EntryCompactRow: View {
    let entry: TimeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.dateLabel)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                Spacer()
                Text(entry.employee)
                    .font(.subheadline.weight(.semibold))
            }

            Text(entry.shiftLabel)
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)

            Text("Hours: \(TimeUtils.formattedHours(entry.hours))")
                .font(.footnote)
        }
    }
}

struct ProfileRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(AppTheme.textPrimary)
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.vertical, 12)
    }
}

struct StatPill: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(AppTheme.textSecondary)
            Text(value)
                .font(.headline)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.pill)
        .cornerRadius(12)
    }
}

struct AppDivider: View {
    var body: some View {
        Rectangle()
            .fill(AppTheme.divider)
            .frame(height: 1)
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.accent.opacity(configuration.isPressed ? 0.85 : 1))
            .cornerRadius(14)
            .shadow(color: AppTheme.accent.opacity(0.35), radius: 8, x: 0, y: 6)
    }
}

struct SecondaryPillButtonStyle: ButtonStyle {
    var isDestructive: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(isDestructive ? AppTheme.destructive : AppTheme.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                (isDestructive ? AppTheme.destructive : AppTheme.accent)
                    .opacity(configuration.isPressed ? 0.25 : 0.16)
            )
            .cornerRadius(999)
    }
}
