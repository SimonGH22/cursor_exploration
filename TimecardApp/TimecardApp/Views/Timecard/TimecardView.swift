import SwiftUI

struct TimecardView: View {
    @State private var selectedDate = Date()
    @State private var clockInTime = Date()
    @State private var clockOutTime = Date()
    @State private var breakDuration: Double = 60
    @State private var selectedProject = Project.samples[0]
    @State private var selectedTask = "Equipment Operation"
    @State private var notes = ""
    @State private var isClockedIn = false
    @State private var showingProjectPicker = false
    
    private let tasks = ["Equipment Operation", "Inspection", "Concrete Work", "Documentation", "Supervision", "Training"]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundLight
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                TimecardHeader(date: selectedDate)
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Clock Status Card
                        ClockStatusCard(
                            isClockedIn: isClockedIn,
                            clockInTime: clockInTime,
                            onToggle: toggleClock
                        )
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Date Selection Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Entry Date")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                DatePickerField(
                                    label: "Date",
                                    date: $selectedDate,
                                    displayedComponents: .date
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Time Entry Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Time Details")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                HStack(spacing: AppSpacing.md) {
                                    DatePickerField(
                                        label: "Clock In",
                                        date: $clockInTime,
                                        displayedComponents: .hourAndMinute
                                    )
                                    
                                    DatePickerField(
                                        label: "Clock Out",
                                        date: $clockOutTime,
                                        displayedComponents: .hourAndMinute
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text("Break Duration")
                                        .font(AppFont.subheadline)
                                        .foregroundColor(.textSecondary)
                                    
                                    HStack {
                                        Text("\(Int(breakDuration)) min")
                                            .font(AppFont.body)
                                            .foregroundColor(.textPrimary)
                                            .frame(width: 80)
                                        
                                        Slider(value: $breakDuration, in: 0...120, step: 15)
                                            .tint(.primaryOrange)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Project & Task Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Project Details")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                // Project Picker
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text("Project")
                                        .font(AppFont.subheadline)
                                        .foregroundColor(.textSecondary)
                                    
                                    Button(action: { showingProjectPicker = true }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(selectedProject.name)
                                                    .font(AppFont.body)
                                                    .foregroundColor(.textPrimary)
                                                Text(selectedProject.code)
                                                    .font(AppFont.caption)
                                                    .foregroundColor(.textSecondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.textTertiary)
                                        }
                                        .padding(AppSpacing.sm)
                                        .background(Color.backgroundGray)
                                        .cornerRadius(AppRadius.small)
                                    }
                                }
                                
                                // Task Picker
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text("Task")
                                        .font(AppFont.subheadline)
                                        .foregroundColor(.textSecondary)
                                    
                                    Menu {
                                        ForEach(tasks, id: \.self) { task in
                                            Button(task) {
                                                selectedTask = task
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedTask)
                                                .font(AppFont.body)
                                                .foregroundColor(.textPrimary)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.textTertiary)
                                        }
                                        .padding(AppSpacing.sm)
                                        .background(Color.backgroundGray)
                                        .cornerRadius(AppRadius.small)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Notes Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Notes")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $notes)
                                    .font(AppFont.body)
                                    .frame(minHeight: 80)
                                    .padding(AppSpacing.xs)
                                    .background(Color.backgroundGray)
                                    .cornerRadius(AppRadius.small)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Action Buttons
                        VStack(spacing: AppSpacing.sm) {
                            PrimaryButton(title: "Submit Entry") {
                                submitEntry()
                            }
                            
                            SecondaryButton(title: "Save as Draft") {
                                saveDraft()
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
        .sheet(isPresented: $showingProjectPicker) {
            ProjectPickerView(selectedProject: $selectedProject)
        }
    }
    
    private func toggleClock() {
        isClockedIn.toggle()
        if isClockedIn {
            clockInTime = Date()
        } else {
            clockOutTime = Date()
        }
    }
    
    private func submitEntry() {
        // Handle submit
    }
    
    private func saveDraft() {
        // Handle save draft
    }
}

// MARK: - Timecard Header
struct TimecardHeader: View {
    let date: Date
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.primaryOrange
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: AppSpacing.xs) {
                Text("Timecard")
                    .font(AppFont.title2)
                    .foregroundColor(.white)
                
                Text(dateFormatter.string(from: date))
                    .font(AppFont.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, AppSpacing.md)
        }
        .frame(height: 80)
    }
}

// MARK: - Clock Status Card
struct ClockStatusCard: View {
    let isClockedIn: Bool
    let clockInTime: Date
    var onToggle: () -> Void
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        SectionCard {
            VStack(spacing: AppSpacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Status")
                            .font(AppFont.caption)
                            .foregroundColor(.textSecondary)
                        
                        HStack(spacing: AppSpacing.xs) {
                            Circle()
                                .fill(isClockedIn ? Color.statusGreen : Color.statusRed)
                                .frame(width: 10, height: 10)
                            
                            Text(isClockedIn ? "Clocked In" : "Clocked Out")
                                .font(AppFont.headline)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    Spacer()
                    
                    if isClockedIn {
                        VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                            Text("Since")
                                .font(AppFont.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text(timeFormatter.string(from: clockInTime))
                                .font(AppFont.headline)
                                .foregroundColor(.primaryOrange)
                        }
                    }
                }
                
                Button(action: onToggle) {
                    HStack {
                        Image(systemName: isClockedIn ? "clock.badge.xmark" : "clock.badge.checkmark")
                            .font(.system(size: 18))
                        
                        Text(isClockedIn ? "Clock Out" : "Clock In")
                            .font(AppFont.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.sm)
                    .background(isClockedIn ? Color.statusRed : Color.statusGreen)
                    .foregroundColor(.white)
                    .cornerRadius(AppRadius.medium)
                }
            }
        }
    }
}

// MARK: - Project Picker View
struct ProjectPickerView: View {
    @Binding var selectedProject: Project
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(Project.samples) { project in
                Button(action: {
                    selectedProject = project
                    dismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(project.name)
                                .font(AppFont.body)
                                .foregroundColor(.textPrimary)
                            
                            HStack(spacing: AppSpacing.sm) {
                                Text(project.code)
                                    .font(AppFont.caption)
                                    .foregroundColor(.textSecondary)
                                
                                Text("•")
                                    .foregroundColor(.textTertiary)
                                
                                Text(project.location)
                                    .font(AppFont.caption)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        if selectedProject.id == project.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primaryOrange)
                        }
                    }
                    .padding(.vertical, AppSpacing.xs)
                }
            }
            .navigationTitle("Select Project")
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
}

#Preview {
    TimecardView()
}
