import SwiftUI
import UIKit

enum AppTab: Hashable {
    case timecard
    case entries
    case summary
    case profile
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
        .tint(Color.blue)
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
                        }
                        Divider()

                        FormRow(title: "Date *") {
                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                        }
                        Divider()

                        FormRow(title: "Start time *") {
                            DatePicker(
                                "",
                                selection: $startTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                        }
                        Divider()

                        FormRow(title: "End time *") {
                            DatePicker(
                                "",
                                selection: $endTime,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                        }
                        Divider()

                        FormRow(title: "Break minutes") {
                            HStack(spacing: 8) {
                                Text("\(breakMinutes)m")
                                    .foregroundColor(.primary)
                                Stepper("", value: $breakMinutes, in: 0...180, step: 5)
                                    .labelsHidden()
                            }
                        }
                        Divider()

                        FormRow(title: "Project or role") {
                            TextField("Fulfillment lead", text: $project)
                                .multilineTextAlignment(.trailing)
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
                                .foregroundColor(.secondary)
                                .padding(.top, 10)
                                .padding(.leading, 14)
                        }

                        TextEditor(text: $notes)
                            .frame(minHeight: 90)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color(.secondarySystemBackground))
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
                    .foregroundColor(statusIsError ? .red : .secondary)
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
                        .foregroundColor(.blue)
                    }

                    let recentEntries = Array(store.entries.prefix(3))
                    if recentEntries.isEmpty {
                        Text("No time entries yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(Array(recentEntries.enumerated()), id: \.element.id) { index, entry in
                            EntryCompactRow(entry: entry)
                            if index < recentEntries.count - 1 {
                                Divider()
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
                        .foregroundColor(.secondary)
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
                    Divider()
                    ProfileRow(label: "Email", value: "diana.lane@email.com")
                    Divider()
                    ProfileRow(label: "Phone", value: "+1 602-539-4782")
                    Divider()
                    ProfileRow(label: "Company", value: "Ultra Inc")
                }
            }

            Card {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Signature")
                        .font(.headline)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            .frame(height: 140)

                        Text("Diana Stone")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .foregroundColor(.blue)
                    }

                    Button("Clear signature") {}
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.blue)
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
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    AppHeader(title: title)
                    content()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
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

            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.blue)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.headline)
                }
                .foregroundColor(.primary)
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
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

struct FormRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            content()
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

                Divider()

                Text("Hours by employee")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                let totals = store.employeeTotals()
                if totals.isEmpty {
                    Text("No employee totals yet.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(totals.enumerated()), id: \.element.name) { index, item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(TimeUtils.formattedHours(item.hours))
                                .foregroundColor(.secondary)
                        }

                        if index < totals.count - 1 {
                            Divider()
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
                            .foregroundColor(.secondary)
                        Text(entry.employee)
                            .font(.headline)
                    }

                    Spacer()

                    if let onDelete = onDelete {
                        Button(role: .destructive, action: onDelete) {
                            Image(systemName: "trash")
                        }
                    }
                }

                Text("\(entry.shiftLabel) | Break \(entry.breakMinutes)m")
                    .foregroundColor(.secondary)

                Text("Hours: \(TimeUtils.formattedHours(entry.hours))")
                    .font(.subheadline)

                if !entry.project.isEmpty {
                    Text("Project: \(entry.project)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                if !entry.notes.isEmpty {
                    Text("Notes: \(entry.notes)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
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
                    .foregroundColor(.secondary)
                Spacer()
                Text(entry.employee)
                    .font(.subheadline.weight(.semibold))
            }

            Text(entry.shiftLabel)
                .font(.subheadline)
                .foregroundColor(.secondary)

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
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
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
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.blue.opacity(configuration.isPressed ? 0.85 : 1))
            .cornerRadius(14)
            .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 6)
    }
}

struct SecondaryPillButtonStyle: ButtonStyle {
    var isDestructive: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundColor(isDestructive ? .red : .blue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                (isDestructive ? Color.red : Color.blue)
                    .opacity(configuration.isPressed ? 0.2 : 0.12)
            )
            .cornerRadius(999)
    }
}
