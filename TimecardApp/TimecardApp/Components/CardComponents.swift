import SwiftUI

// MARK: - Profile Avatar
struct ProfileAvatar: View {
    let initials: String
    var size: CGFloat = 80
    var backgroundColor: Color = .primaryOrange
    var foregroundColor: Color = .white
    var borderColor: Color = .white
    var borderWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
            
            Text(initials)
                .font(AppFont.bold(size * 0.35))
                .foregroundColor(foregroundColor)
        }
        .overlay(
            Circle()
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .cardShadow()
    }
}

// MARK: - Status Pill
struct StatusPill: View {
    let text: String
    var backgroundColor: Color = .primaryOrange
    var foregroundColor: Color = .white
    
    var body: some View {
        Text(text)
            .font(AppFont.caption2)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs + 2)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(AppRadius.pill)
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppSpacing.md
    
    init(padding: CGFloat = AppSpacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(padding)
        .background(Color.backgroundCard)
        .cornerRadius(AppRadius.large)
        .cardShadow()
    }
}

// MARK: - Menu Row
struct MenuRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var iconColor: Color = .primaryOrange
    var showChevron: Bool = true
    var showDivider: Bool = true
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 0) {
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(iconColor)
                        .frame(width: 28, height: 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(AppFont.body)
                            .foregroundColor(.textPrimary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(AppFont.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if showChevron {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.textTertiary)
                    }
                }
                .padding(.vertical, AppSpacing.sm)
                
                if showDivider {
                    Divider()
                        .padding(.leading, 44)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = .textPrimary
    
    var body: some View {
        HStack {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(AppFont.body)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

// MARK: - Signature Card
struct SignatureCard: View {
    var signatureImage: Data?
    var onTapToSign: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: "signature")
                    .font(.system(size: 18))
                    .foregroundColor(.primaryOrange)
                
                Text("Signature")
                    .font(AppFont.headline)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if signatureImage == nil {
                    Button(action: { onTapToSign?() }) {
                        Text("Tap to Sign")
                            .font(AppFont.caption)
                            .foregroundColor(.primaryOrange)
                    }
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .fill(Color.backgroundGray)
                    .frame(height: 100)
                
                if let imageData = signatureImage,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding(AppSpacing.sm)
                } else {
                    VStack(spacing: AppSpacing.xs) {
                        Image(systemName: "pencil.tip.crop.circle")
                            .font(.system(size: 28))
                            .foregroundColor(.textTertiary)
                        
                        Text("No signature on file")
                            .font(AppFont.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Time Entry Card
struct TimeEntryCard: View {
    let entry: TimeEntry
    var onTap: (() -> Void)?
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateFormatter.string(from: entry.date))
                            .font(AppFont.headline)
                            .foregroundColor(.textPrimary)
                        
                        Text(entry.project)
                            .font(AppFont.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    StatusPill(
                        text: entry.status.rawValue,
                        backgroundColor: statusColor(for: entry.status),
                        foregroundColor: .white
                    )
                }
                
                Divider()
                
                HStack(spacing: AppSpacing.lg) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Clock In")
                            .font(AppFont.caption)
                            .foregroundColor(.textTertiary)
                        Text(timeFormatter.string(from: entry.clockIn))
                            .font(AppFont.subheadline)
                            .foregroundColor(.textPrimary)
                    }
                    
                    if let clockOut = entry.clockOut {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Clock Out")
                                .font(AppFont.caption)
                                .foregroundColor(.textTertiary)
                            Text(timeFormatter.string(from: clockOut))
                                .font(AppFont.subheadline)
                                .foregroundColor(.textPrimary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Total")
                            .font(AppFont.caption)
                            .foregroundColor(.textTertiary)
                        Text(String(format: "%.1fh", entry.totalHours))
                            .font(AppFont.headline)
                            .foregroundColor(.primaryOrange)
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(Color.backgroundCard)
            .cornerRadius(AppRadius.large)
            .cardShadow()
        }
        .buttonStyle(PlainButtonStyle())
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

// MARK: - Summary Card
struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = .primaryOrange
    var subtitle: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(AppFont.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Text(value)
                .font(AppFont.title)
                .foregroundColor(.textPrimary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(AppFont.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(Color.backgroundCard)
        .cornerRadius(AppRadius.large)
        .cardShadow()
    }
}

// MARK: - Custom Header
struct CustomHeader: View {
    var title: String = ""
    var showBackButton: Bool = false
    var onBack: (() -> Void)?
    var trailingContent: AnyView?
    
    var body: some View {
        ZStack {
            Color.primaryOrange
                .ignoresSafeArea(edges: .top)
            
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                
                if !title.isEmpty {
                    Text(title)
                        .font(AppFont.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if let trailing = trailingContent {
                    trailing
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .frame(height: 56)
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(title)
                    .font(AppFont.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(isDisabled ? Color.textTertiary : Color.primaryOrange)
            .foregroundColor(.white)
            .cornerRadius(AppRadius.medium)
            .cardShadow()
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.md)
                .background(Color.backgroundGray)
                .foregroundColor(.textPrimary)
                .cornerRadius(AppRadius.medium)
        }
    }
}

// MARK: - Form Field
struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.textSecondary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(AppFont.body)
            .padding(AppSpacing.sm)
            .background(Color.backgroundGray)
            .cornerRadius(AppRadius.small)
            .keyboardType(keyboardType)
        }
    }
}

// MARK: - Date Picker Field
struct DatePickerField: View {
    let label: String
    @Binding var date: Date
    var displayedComponents: DatePicker.Components = [.date]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.textSecondary)
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .labelsHidden()
                .padding(AppSpacing.xs)
                .background(Color.backgroundGray)
                .cornerRadius(AppRadius.small)
        }
    }
}

// MARK: - Toggle Row
struct ToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    var iconColor: Color = .primaryOrange
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)
            
            Text(title)
                .font(AppFont.body)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.primaryOrange)
        }
        .padding(.vertical, AppSpacing.xs)
    }
}
