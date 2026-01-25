import SwiftUI

struct TimeOffRequestView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var requestType: RequestType = .vacation
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var reason = ""
    @State private var isSubmitting = false
    
    enum RequestType: String, CaseIterable {
        case vacation = "Vacation"
        case sick = "Sick Leave"
        case personal = "Personal"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .vacation: return "sun.max.fill"
            case .sick: return "cross.case.fill"
            case .personal: return "person.fill"
            case .other: return "ellipsis.circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Request Type
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Request Type")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: AppSpacing.sm) {
                                    ForEach(RequestType.allCases, id: \.self) { type in
                                        RequestTypeButton(
                                            type: type,
                                            isSelected: requestType == type,
                                            action: { requestType = type }
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Date Selection
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Dates")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                DatePickerField(
                                    label: "Start Date",
                                    date: $startDate,
                                    displayedComponents: .date
                                )
                                
                                DatePickerField(
                                    label: "End Date",
                                    date: $endDate,
                                    displayedComponents: .date
                                )
                                
                                // Duration Display
                                HStack {
                                    Image(systemName: "calendar.badge.clock")
                                        .foregroundColor(.primaryOrange)
                                    
                                    Text("Duration: \(daysBetween) day(s)")
                                        .font(AppFont.subheadline)
                                        .foregroundColor(.textSecondary)
                                }
                                .padding(.top, AppSpacing.xs)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Reason
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text("Reason (Optional)")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                TextEditor(text: $reason)
                                    .font(AppFont.body)
                                    .frame(minHeight: 100)
                                    .padding(AppSpacing.xs)
                                    .background(Color.backgroundGray)
                                    .cornerRadius(AppRadius.small)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Submit Button
                        PrimaryButton(title: "Submit Request", isLoading: isSubmitting) {
                            submitRequest()
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        SecondaryButton(title: "Cancel") {
                            dismiss()
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Request Time Off")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryOrange)
                }
            }
        }
    }
    
    private var daysBetween: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return max(1, (components.day ?? 0) + 1)
    }
    
    private func submitRequest() {
        isSubmitting = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            dismiss()
        }
    }
}

// MARK: - Request Type Button
struct RequestTypeButton: View {
    let type: TimeOffRequestView.RequestType
    let isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: type.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .primaryOrange)
                
                Text(type.rawValue)
                    .font(AppFont.caption)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(isSelected ? Color.primaryOrange : Color.backgroundGray)
            .cornerRadius(AppRadius.medium)
        }
    }
}

#Preview {
    TimeOffRequestView()
}
