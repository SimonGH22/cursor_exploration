import Foundation

final class TimeEntryStore: ObservableObject {
    @Published private(set) var entries: [TimeEntry] = []

    private let storageKey = "timecard.entries.v1"

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init() {
        load()
    }

    var totalHours: Double {
        entries.reduce(0) { $0 + $1.hours }
    }

    var overtimeHours: Double {
        max(0, totalHours - 40)
    }

    func add(_ entry: TimeEntry) {
        entries.append(entry)
        sortEntries()
        save()
    }

    func update(_ entry: TimeEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = entry
        sortEntries()
        save()
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func remove(_ entry: TimeEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func clear() {
        entries.removeAll()
        save()
    }

    func addSampleEntries() {
        entries.insert(contentsOf: sampleEntries(), at: 0)
        sortEntries()
        save()
    }

    func exportCSV() -> String {
        var rows: [String] = [
            "Date,Employee,Start,End,Break Minutes,Hours,Project,Notes"
        ]

        for entry in entries {
            let row = [
                TimeUtils.formattedDate(entry.date),
                entry.employee,
                TimeUtils.formattedTime(minutes: entry.startMinutes),
                TimeUtils.formattedTime(minutes: entry.endMinutes),
                "\(entry.breakMinutes)",
                TimeUtils.formattedHours(entry.hours),
                entry.project,
                entry.notes
            ]
            .map(csvEscape)
            .joined(separator: ",")

            rows.append(row)
        }

        return rows.joined(separator: "\n")
    }

    func employeeTotals() -> [(name: String, hours: Double)] {
        let grouped = Dictionary(grouping: entries, by: { $0.employee })
        let totals = grouped.mapValues { group in
            group.reduce(0) { $0 + $1.hours }
        }

        return totals
            .map { (name: $0.key, hours: $0.value) }
            .sorted { lhs, rhs in
                lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            entries = try decoder.decode([TimeEntry].self, from: data)
            sortEntries()
        } catch {
            entries = []
        }
    }

    private func save() {
        do {
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Ignore persistence errors in this sample.
        }
    }

    private func sortEntries() {
        entries.sort { $0.sortKey > $1.sortKey }
    }

    private func csvEscape(_ value: String) -> String {
        let needsQuotes = value.contains(",") || value.contains("\n") || value.contains("\"")
        if needsQuotes {
            let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(escaped)\""
        }
        return value
    }

    private func sampleEntries() -> [TimeEntry] {
        let today = TimeUtils.startOfDay(for: Date())
        let yesterday = TimeUtils.calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let twoDaysAgo = TimeUtils.calendar.date(byAdding: .day, value: -2, to: today) ?? today

        return [
            TimeEntry(
                employee: "Alex Morgan",
                date: today,
                startMinutes: 8 * 60,
                endMinutes: 16 * 60 + 30,
                breakMinutes: 30,
                project: "Fulfillment",
                notes: "Morning shift"
            ),
            TimeEntry(
                employee: "Jordan Lee",
                date: today,
                startMinutes: 10 * 60,
                endMinutes: 19 * 60,
                breakMinutes: 45,
                project: "Customer care",
                notes: "Handled escalations"
            ),
            TimeEntry(
                employee: "Alex Morgan",
                date: yesterday,
                startMinutes: 9 * 60,
                endMinutes: 17 * 60,
                breakMinutes: 30,
                project: "Inventory",
                notes: "Cycle counts"
            ),
            TimeEntry(
                employee: "Riley Chen",
                date: twoDaysAgo,
                startMinutes: 7 * 60 + 30,
                endMinutes: 15 * 60 + 30,
                breakMinutes: 20,
                project: "Receiving",
                notes: "Dock support"
            )
        ]
    }
}
