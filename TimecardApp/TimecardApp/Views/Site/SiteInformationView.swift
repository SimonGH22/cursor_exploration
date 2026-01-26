import SwiftUI

struct SiteInformationView: View {
    @Environment(\.dismiss) var dismiss
    let site: Site
    
    init(site: Site = Site.sample) {
        self.site = site
    }
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                SiteNavigationBar(
                    title: "Site Information",
                    onBack: { dismiss() }
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        // Shift Details Section
                        SectionTitle(title: "Shift Details")
                        ShiftDetailsCard(shiftDetails: site.shiftDetails)
                        
                        // Site Rules Section
                        SectionTitle(title: "Site Rules")
                        SiteRulesCard(rules: site.siteRules)
                        
                        // Site Working Days Section
                        SectionTitle(title: "Site Working Days")
                        WorkingDaysCard(selectedDays: site.workingDays)
                        
                        // Holidays Section
                        SectionTitle(title: "Holidays")
                        HolidaysCard(holidays: site.holidays)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.top, AppSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Section Title
struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(AppFont.headline)
            .foregroundColor(.white)
    }
}

// MARK: - Site Navigation Bar
struct SiteNavigationBar: View {
    let title: String
    var onBack: (() -> Void)?
    var onMenu: (() -> Void)?
    
    var body: some View {
        HStack {
            // Back Button
            Button(action: { onBack?() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Back")
                        .font(AppFont.body)
                }
                .foregroundColor(.white)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(Color.darkCardBackground)
                .cornerRadius(AppRadius.pill)
            }
            
            Spacer()
            
            Text(title)
                .font(AppFont.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            // Menu Button
            Button(action: { onMenu?() }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.darkCardBackground)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
    }
}

// MARK: - Shift Details Card
struct ShiftDetailsCard: View {
    let shiftDetails: ShiftDetails
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            // Shift Type
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.6))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Shift Type")
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.6))
                    Text(shiftDetails.shiftType.rawValue)
                        .font(AppFont.headline)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Start Time
            VStack(alignment: .leading, spacing: 2) {
                Text("Start Time")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.6))
                Text(timeFormatter.string(from: shiftDetails.startTime).lowercased())
                    .font(AppFont.headline)
                    .foregroundColor(.white)
            }
            
            // End Time
            VStack(alignment: .leading, spacing: 2) {
                Text("End Time")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.6))
                Text(timeFormatter.string(from: shiftDetails.endTime).lowercased())
                    .font(AppFont.headline)
                    .foregroundColor(.white)
            }
        }
        .padding(AppSpacing.md)
        .background(Color.darkCardBackground)
        .cornerRadius(AppRadius.large)
    }
}

// MARK: - Site Rules Card
struct SiteRulesCard: View {
    let rules: [SiteRule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            ForEach(rules) { rule in
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(rule.title)
                        .font(AppFont.headline)
                        .foregroundColor(.white)
                    
                    Text(rule.description)
                        .font(AppFont.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                if rule.id != rules.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.1))
                }
            }
        }
        .padding(AppSpacing.md)
        .background(Color.darkCardBackground)
        .cornerRadius(AppRadius.large)
    }
}

// MARK: - Working Days Card
struct WorkingDaysCard: View {
    let selectedDays: [DayOfWeek]
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(DayOfWeek.orderedDays) { day in
                VStack(spacing: AppSpacing.xxs) {
                    ZStack {
                        Circle()
                            .fill(selectedDays.contains(where: { $0.index == day.index }) ? Color.white : Color.clear)
                            .frame(width: 40, height: 40)
                        
                        Text(day.rawValue)
                            .font(AppFont.headline)
                            .foregroundColor(selectedDays.contains(where: { $0.index == day.index }) ? .black : .white.opacity(0.4))
                    }
                    
                    if day == .sunday || day == .saturday {
                        Text(day.fullName)
                            .font(AppFont.caption2)
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(AppSpacing.md)
        .background(Color.darkCardBackground)
        .cornerRadius(AppRadius.large)
    }
}

// MARK: - Holidays Card
struct HolidaysCard: View {
    let holidays: [Holiday]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Name")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Date")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                    .frame(width: 120, alignment: .leading)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Rows
            ForEach(holidays) { holiday in
                HStack {
                    Text(holiday.name)
                        .font(AppFont.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(holiday.formattedDate)
                        .font(AppFont.body)
                        .foregroundColor(.primaryOrange)
                        .frame(width: 120, alignment: .leading)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                
                if holiday.id != holidays.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.1))
                }
            }
        }
        .background(Color.darkCardBackground)
        .cornerRadius(AppRadius.large)
    }
}

// MARK: - Dark Theme Colors Extension
extension Color {
    static let darkCardBackground = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1F
    static let darkBackground = Color.black
}

#Preview {
    SiteInformationView()
}
