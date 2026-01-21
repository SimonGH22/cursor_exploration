import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var store = TimeEntryStore()

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
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add time entry")
                            .font(.headline)
                        Text("All fields marked with * are required.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Employee name *", text: $employee)
                            .textInputAutocapitalization(.words)
                        DatePicker("Date *", selection: $date, displayedComponents: .date)
                        DatePicker("Start time *", selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End time *", selection: $endTime, displayedComponents: .hourAndMinute)

                        Stepper(value: $breakMinutes, in: 0...180, step: 5) {
                            Text("Break minutes: \(breakMinutes)")
                        }

                        TextField("Project or role", text: $project)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Notes")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            TextEditor(text: $notes)
                                .frame(minHeight: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.secondary.opacity(0.2))
                                )
                        }

                        Button("Add entry", action: addEntry)
                            .buttonStyle(.borderedProminent)

                        actionButtons

                        if !statusMessage.isEmpty {
                            Text(statusMessage)
                                .font(.footnote)
                                .foregroundColor(statusIsError ? .red : .secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Summary") {
                    summaryCards
                    employeeTotalsView
                }

                Section("Entries") {
                    if store.entries.isEmpty {
                        Text("No time entries yet. Add one above to get started.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(store.entries) { entry in
                            TimeEntryRow(entry: entry)
                        }
                        .onDelete(perform: store.remove)
                    }
                }
            }
            .navigationTitle("Timecard Sample")
            .toolbar {
                EditButton()
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
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button("Add sample data") {
                store.addSampleEntries()
                setStatus("Sample data added.", isError: false)
            }
            Button("Copy CSV") {
                copyCSV()
            }
            Button("Clear all", role: .destructive) {
                showingClearConfirm = true
            }
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(label: "Entries", value: "\(store.entries.count)")
            SummaryCard(label: "Total hours", value: TimeUtils.formattedHours(store.totalHours))
            SummaryCard(label: "Overtime (40h+)", value: TimeUtils.formattedHours(store.overtimeHours))
        }
        .padding(.vertical, 4)
    }

    private var employeeTotalsView: some View {
        let totals = store.employeeTotals()
        return VStack(alignment: .leading, spacing: 8) {
            Text("Hours by employee")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if totals.isEmpty {
                Text("No employee totals yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(totals, id: \.name) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(TimeUtils.formattedHours(item.hours))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
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

struct SummaryCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct TimeEntryRow: View {
    let entry: TimeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.dateLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(entry.employee)
                    .font(.headline)
            }

            Text("\(entry.shiftLabel) | Break \(entry.breakMinutes)m")
                .font(.subheadline)
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
        .padding(.vertical, 4)
    }
}
