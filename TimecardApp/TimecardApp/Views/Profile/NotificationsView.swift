import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notifications = AppNotification.samples
    @State private var notificationsEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Settings Card
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Notification Settings")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                ToggleRow(
                                    icon: "bell.fill",
                                    title: "Enable Notifications",
                                    isOn: $notificationsEnabled,
                                    iconColor: .primaryOrange
                                )
                                
                                Divider()
                                
                                ToggleRow(
                                    icon: "envelope.fill",
                                    title: "Email Notifications",
                                    isOn: $emailNotifications,
                                    iconColor: .statusBlue
                                )
                                
                                Divider()
                                
                                ToggleRow(
                                    icon: "iphone",
                                    title: "Push Notifications",
                                    isOn: $pushNotifications,
                                    iconColor: .statusGreen
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Recent Notifications
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            HStack {
                                Text("RECENT NOTIFICATIONS")
                                    .sectionHeaderStyle()
                                
                                Spacer()
                                
                                if !notifications.isEmpty {
                                    Button("Clear All") {
                                        withAnimation {
                                            notifications.removeAll()
                                        }
                                    }
                                    .font(AppFont.caption)
                                    .foregroundColor(.primaryOrange)
                                }
                            }
                            .padding(.horizontal, AppSpacing.md)
                            
                            if notifications.isEmpty {
                                EmptyNotificationsView()
                                    .padding(.horizontal, AppSpacing.md)
                            } else {
                                ForEach(notifications) { notification in
                                    NotificationCard(
                                        notification: notification,
                                        onDismiss: {
                                            withAnimation {
                                                notifications.removeAll { $0.id == notification.id }
                                            }
                                        }
                                    )
                                    .padding(.horizontal, AppSpacing.md)
                                }
                            }
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Notifications")
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

// MARK: - Notification Card
struct NotificationCard: View {
    let notification: AppNotification
    var onDismiss: (() -> Void)?
    
    private var timeFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 40, height: 40)
                
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                HStack {
                    Text(notification.title)
                        .font(AppFont.headline)
                        .foregroundColor(.textPrimary)
                    
                    if !notification.isRead {
                        Circle()
                            .fill(Color.primaryOrange)
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                    
                    Text(timeFormatter.localizedString(for: notification.date, relativeTo: Date()))
                        .font(AppFont.caption)
                        .foregroundColor(.textTertiary)
                }
                
                Text(notification.message)
                    .font(AppFont.subheadline)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding(AppSpacing.md)
        .background(notification.isRead ? Color.backgroundCard : Color.primaryOrange.opacity(0.05))
        .cornerRadius(AppRadius.large)
        .cardShadow()
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDismiss?()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var iconName: String {
        switch notification.type {
        case .approval: return "checkmark"
        case .rejection: return "xmark"
        case .reminder: return "bell.fill"
        case .system: return "gear"
        }
    }
    
    private var iconBackgroundColor: Color {
        switch notification.type {
        case .approval: return .statusGreen
        case .rejection: return .statusRed
        case .reminder: return .primaryOrange
        case .system: return .statusBlue
        }
    }
}

// MARK: - Empty Notifications View
struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundColor(.textTertiary)
            
            Text("No Notifications")
                .font(AppFont.headline)
                .foregroundColor(.textPrimary)
            
            Text("You're all caught up! New notifications will appear here.")
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

#Preview {
    NotificationsView()
}
