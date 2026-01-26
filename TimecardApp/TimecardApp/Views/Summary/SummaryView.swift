import SwiftUI

struct SummaryView: View {
    @State private var selectedPeriod: TimePeriod = .thisWeek
    @State private var summary = TimeSummary.sample
    @State private var entries = TimeEntry.samples
    
    enum TimePeriod: String, CaseIterable {
        case thisWeek = "This Week"
        case lastWeek = "Last Week"
        case thisMonth = "This Month"
        case lastMonth = "Last Month"
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                SummaryHeader()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Period Selector
                        PeriodSelector(selectedPeriod: $selectedPeriod)
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Total Hours Card
                        TotalHoursCard(summary: summary)
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Hours Breakdown
                        HStack(spacing: AppSpacing.md) {
                            SummaryCard(
                                title: "Regular Hours",
                                value: String(format: "%.1f", summary.regularHours),
                                icon: "clock.fill",
                                iconColor: .statusBlue,
                                subtitle: "hrs"
                            )
                            
                            SummaryCard(
                                title: "Overtime",
                                value: String(format: "%.1f", summary.overtimeHours),
                                icon: "clock.badge.exclamationmark.fill",
                                iconColor: .primaryOrange,
                                subtitle: "hrs"
                            )
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Entry Status Summary
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Entry Status")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                EntryStatusRow(
                                    title: "Days Worked",
                                    count: summary.daysWorked,
                                    icon: "calendar",
                                    color: .statusBlue
                                )
                                
                                Divider()
                                
                                EntryStatusRow(
                                    title: "Pending Approval",
                                    count: summary.pendingEntries,
                                    icon: "hourglass",
                                    color: .statusYellow
                                )
                                
                                Divider()
                                
                                EntryStatusRow(
                                    title: "Approved",
                                    count: summary.approvedEntries,
                                    icon: "checkmark.circle.fill",
                                    color: .statusGreen
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Weekly Chart Card
                        WeeklyChartCard()
                            .padding(.horizontal, AppSpacing.md)
                        
                        // Quick Actions
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Quick Actions")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: AppSpacing.md) {
                                    QuickActionButton(
                                        title: "Export",
                                        icon: "square.and.arrow.up",
                                        color: .primaryOrange
                                    ) {
                                        // Export action
                                    }
                                    
                                    QuickActionButton(
                                        title: "Print",
                                        icon: "printer",
                                        color: .statusBlue
                                    ) {
                                        // Print action
                                    }
                                    
                                    QuickActionButton(
                                        title: "Share",
                                        icon: "paperplane",
                                        color: .statusGreen
                                    ) {
                                        // Share action
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Summary Header
struct SummaryHeader: View {
    var body: some View {
        ZStack {
            Color.primaryOrange
                .ignoresSafeArea(edges: .top)
            
            Text("Summary")
                .font(AppFont.title2)
                .foregroundColor(.white)
        }
        .frame(height: 56)
    }
}

// MARK: - Period Selector
struct PeriodSelector: View {
    @Binding var selectedPeriod: SummaryView.TimePeriod
    
    var body: some View {
        Menu {
            ForEach(SummaryView.TimePeriod.allCases, id: \.self) { period in
                Button(period.rawValue) {
                    selectedPeriod = period
                }
            }
        } label: {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.primaryOrange)
                
                Text(selectedPeriod.rawValue)
                    .font(AppFont.body)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.textTertiary)
            }
            .padding(AppSpacing.md)
            .background(Color.backgroundCard)
            .cornerRadius(AppRadius.medium)
            .cardShadow()
        }
    }
}

// MARK: - Total Hours Card
struct TotalHoursCard: View {
    let summary: TimeSummary
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(
                    LinearGradient(
                        colors: [Color.primaryOrange, Color.primaryOrange.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: AppSpacing.sm) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(String(format: "%.1f", summary.totalHours))
                    .font(AppFont.bold(48))
                    .foregroundColor(.white)
                
                Text("Total Hours")
                    .font(AppFont.headline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, AppSpacing.xl)
        }
        .cardShadow()
    }
}

// MARK: - Entry Status Row
struct EntryStatusRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(AppFont.body)
                    .foregroundColor(.textPrimary)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(AppFont.headline)
                .foregroundColor(color)
        }
    }
}

// MARK: - Weekly Chart Card
struct WeeklyChartCard: View {
    let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let hours: [Double] = [8.5, 9.0, 8.0, 8.5, 8.5, 0, 0]
    
    var maxHours: Double {
        hours.max() ?? 10
    }
    
    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Text("Weekly Overview")
                    .font(AppFont.headline)
                    .foregroundColor(.textPrimary)
                
                HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                    ForEach(0..<7, id: \.self) { index in
                        VStack(spacing: AppSpacing.xxs) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(hours[index] > 0 ? Color.primaryOrange : Color.backgroundGray)
                                .frame(width: 30, height: max(4, CGFloat(hours[index] / maxHours) * 80))
                            
                            Text(weekDays[index])
                                .font(AppFont.caption2)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 100)
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppFont.caption)
                    .foregroundColor(.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(Color.backgroundGray)
            .cornerRadius(AppRadius.medium)
        }
    }
}

#Preview {
    SummaryView()
}
