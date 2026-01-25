import SwiftUI

struct EntriesView: View {
    @State private var entries = TimeEntry.samples
    @State private var selectedFilter: EntryFilter = .all
    @State private var searchText = ""
    @State private var showingEntryDetail: TimeEntry?
    
    enum EntryFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case submitted = "Submitted"
        case approved = "Approved"
    }
    
    var filteredEntries: [TimeEntry] {
        var result = entries
        
        if selectedFilter != .all {
            result = result.filter { entry in
                switch selectedFilter {
                case .all: return true
                case .pending: return entry.status == .pending || entry.status == .draft
                case .submitted: return entry.status == .submitted
                case .approved: return entry.status == .approved
                }
            }
        }
        
        if !searchText.isEmpty {
            result = result.filter { entry in
                entry.project.localizedCaseInsensitiveContains(searchText) ||
                entry.task.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                EntriesHeader()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Search Bar
                        SearchBar(text: $searchText)
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Filter Pills
                        FilterPillsView(selectedFilter: $selectedFilter)
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Stats Summary
                        EntriesStatsCard(entries: entries)
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Recent Entries Section
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("RECENT ENTRIES")
                                .sectionHeaderStyle()
                                .padding(.horizontal, AppSpacing.md)
                            
                            if filteredEntries.isEmpty {
                                EmptyEntriesView()
                                    .padding(.horizontal, AppSpacing.md)
                            } else {
                                ForEach(filteredEntries) { entry in
                                    TimeEntryCard(entry: entry) {
                                        showingEntryDetail = entry
                                    }
                                    .padding(.horizontal, AppSpacing.md)
                                }
                            }
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $showingEntryDetail) { entry in
            EntryDetailView(entry: entry)
        }
    }
}

// MARK: - Entries Header
struct EntriesHeader: View {
    var body: some View {
        ZStack {
            Color.primaryOrange
                .ignoresSafeArea(edges: .top)
            
            Text("Time Entries")
                .font(AppFont.title2)
                .foregroundColor(.white)
        }
        .frame(height: 56)
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textTertiary)
            
            TextField("Search entries...", text: $text)
                .font(AppFont.body)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(AppSpacing.sm)
        .background(Color.backgroundCard)
        .cornerRadius(AppRadius.medium)
        .softShadow()
    }
}

// MARK: - Filter Pills View
struct FilterPillsView: View {
    @Binding var selectedFilter: EntriesView.EntryFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(EntriesView.EntryFilter.allCases, id: \.self) { filter in
                    FilterPill(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter,
                        action: { selectedFilter = filter }
                    )
                }
            }
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.subheadline)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(isSelected ? Color.primaryOrange : Color.backgroundCard)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .cornerRadius(AppRadius.pill)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.pill)
                        .stroke(isSelected ? Color.clear : Color.borderLight, lineWidth: 1)
                )
        }
        .softShadow()
    }
}

// MARK: - Entries Stats Card
struct EntriesStatsCard: View {
    let entries: [TimeEntry]
    
    var totalHours: Double {
        entries.reduce(0) { $0 + $1.totalHours }
    }
    
    var pendingCount: Int {
        entries.filter { $0.status == .pending || $0.status == .submitted }.count
    }
    
    var approvedCount: Int {
        entries.filter { $0.status == .approved }.count
    }
    
    var body: some View {
        SectionCard {
            HStack(spacing: 0) {
                StatItem(
                    value: String(format: "%.1f", totalHours),
                    label: "Total Hours",
                    icon: "clock.fill",
                    iconColor: .primaryOrange
                )
                
                Divider()
                    .frame(height: 40)
                
                StatItem(
                    value: "\(entries.count)",
                    label: "Entries",
                    icon: "list.bullet",
                    iconColor: .statusBlue
                )
                
                Divider()
                    .frame(height: 40)
                
                StatItem(
                    value: "\(pendingCount)",
                    label: "Pending",
                    icon: "hourglass",
                    iconColor: .statusYellow
                )
            }
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(AppFont.title3)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Empty Entries View
struct EmptyEntriesView: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)
            
            Text("No Entries Found")
                .font(AppFont.headline)
                .foregroundColor(.textPrimary)
            
            Text("Try adjusting your filters or search terms")
                .font(AppFont.subheadline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxl)
        .background(Color.backgroundCard)
        .cornerRadius(AppRadius.large)
        .cardShadow()
    }
}

// MARK: - Entry Detail View
struct EntryDetailView: View {
    let entry: TimeEntry
    @Environment(\.dismiss) var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Status Card
                        SectionCard {
                            HStack {
                                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                    Text("Status")
                                        .font(AppFont.caption)
                                        .foregroundColor(.textSecondary)
                                    
                                    StatusPill(
                                        text: entry.status.rawValue,
                                        backgroundColor: statusColor(for: entry.status)
                                    )
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                                    Text("Total Hours")
                                        .font(AppFont.caption)
                                        .foregroundColor(.textSecondary)
                                    
                                    Text(String(format: "%.1fh", entry.totalHours))
                                        .font(AppFont.title2)
                                        .foregroundColor(.primaryOrange)
                                }
                            }
                        }
                        
                        // Date & Time Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Date & Time")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                InfoRow(label: "Date", value: dateFormatter.string(from: entry.date))
                                Divider()
                                InfoRow(label: "Clock In", value: timeFormatter.string(from: entry.clockIn))
                                Divider()
                                if let clockOut = entry.clockOut {
                                    InfoRow(label: "Clock Out", value: timeFormatter.string(from: clockOut))
                                    Divider()
                                }
                                InfoRow(label: "Break", value: "\(Int(entry.breakDuration / 60)) min")
                            }
                        }
                        
                        // Project Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Project Details")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                InfoRow(label: "Project", value: entry.project)
                                Divider()
                                InfoRow(label: "Task", value: entry.task)
                            }
                        }
                        
                        // Notes Card
                        if !entry.notes.isEmpty {
                            SectionCard {
                                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                    Text("Notes")
                                        .font(AppFont.headline)
                                        .foregroundColor(.textPrimary)
                                    
                                    Text(entry.notes)
                                        .font(AppFont.body)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        
                        // Actions
                        if entry.status == .draft || entry.status == .pending {
                            VStack(spacing: AppSpacing.sm) {
                                PrimaryButton(title: "Edit Entry") {
                                    // Handle edit
                                }
                                
                                if entry.status == .draft {
                                    SecondaryButton(title: "Submit for Approval") {
                                        // Handle submit
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(AppSpacing.md)
                }
            }
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
    
    private func statusColor(for status: EntryStatus) -> Color {
        switch status {
        case .draft: return .textSecondary
        case .pending: return .statusYellow
        case .submitted: return .statusBlue
        case .approved: return .statusGreen
        case .rejected: return .statusRed
        }
    }
}

#Preview {
    EntriesView()
}
