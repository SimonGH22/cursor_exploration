import SwiftUI

struct ProfileView: View {
    @State private var user = User.sample
    @State private var showingEditProfile = false
    @State private var showingTimeOffRequest = false
    @State private var showingLicenses = false
    @State private var showingHelp = false
    @State private var showingNotifications = false
    @State private var showingGallery = false
    @State private var showingSignature = false
    @State private var geolocationEnabled = true
    @State private var showingLogoutAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            Color.backgroundLight
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with avatar
                    ProfileHeader(user: user)
                    
                    // Content
                    VStack(spacing: AppSpacing.md) {
                        // Main Menu Section
                        SectionCard(padding: 0) {
                            VStack(spacing: 0) {
                                MenuRow(
                                    icon: "person.circle.fill",
                                    title: "My Profile",
                                    subtitle: "View and edit your information",
                                    action: { showingEditProfile = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "calendar.badge.clock",
                                    title: "Request Time Off",
                                    subtitle: "Submit vacation or leave requests",
                                    action: { showingTimeOffRequest = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "car.fill",
                                    title: "Driving and Operator Licenses",
                                    subtitle: "Manage your certifications",
                                    action: { showingLicenses = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "questionmark.circle.fill",
                                    title: "Help & Support",
                                    subtitle: "Get assistance",
                                    action: { showingHelp = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    subtitle: "Manage your alerts",
                                    action: { showingNotifications = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "photo.on.rectangle.angled",
                                    title: "Gallery",
                                    subtitle: "View your photos",
                                    showDivider: false,
                                    action: { showingGallery = true }
                                )
                                .padding(.horizontal, AppSpacing.md)
                            }
                            .padding(.vertical, AppSpacing.xs)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Signature Section
                        SectionCard {
                            SignatureCard(
                                signatureImage: user.signatureImage,
                                onTapToSign: { showingSignature = true }
                            )
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Settings Section
                        SectionCard(padding: 0) {
                            VStack(spacing: 0) {
                                ToggleRow(
                                    icon: "location.fill",
                                    title: "Disable Geolocation",
                                    isOn: Binding(
                                        get: { !geolocationEnabled },
                                        set: { geolocationEnabled = !$0 }
                                    ),
                                    iconColor: .statusBlue
                                )
                                .padding(.horizontal, AppSpacing.md)
                            }
                            .padding(.vertical, AppSpacing.sm)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Logout Button
                        SectionCard(padding: 0) {
                            Button(action: { showingLogoutAlert = true }) {
                                HStack(spacing: AppSpacing.md) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.statusRed)
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Logout")
                                        .font(AppFont.body)
                                        .foregroundColor(.statusRed)
                                    
                                    Spacer()
                                }
                                .padding(AppSpacing.md)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Cancel/Close Button
                        SecondaryButton(title: "Cancel") {
                            // Handle cancel action
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: $user)
        }
        .sheet(isPresented: $showingTimeOffRequest) {
            TimeOffRequestView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationsView()
        }
        .sheet(isPresented: $showingSignature) {
            SignatureView()
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                // Handle logout
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
    }
}

// MARK: - Profile Header
struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Orange background
            VStack(spacing: 0) {
                Color.primaryOrange
                    .frame(height: 180)
                
                Color.backgroundLight
                    .frame(height: 60)
            }
            
            // Avatar and info
            VStack(spacing: AppSpacing.sm) {
                ProfileAvatar(
                    initials: user.avatarInitials,
                    size: 100,
                    backgroundColor: .primaryOrange,
                    foregroundColor: .white,
                    borderColor: .white,
                    borderWidth: 5
                )
                .background(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 110, height: 110)
                )
                
                Text(user.fullName)
                    .font(AppFont.title2)
                    .foregroundColor(.textPrimary)
                
                HStack(spacing: AppSpacing.xs) {
                    StatusPill(
                        text: user.role,
                        backgroundColor: .primaryNavy,
                        foregroundColor: .white
                    )
                    
                    StatusPill(
                        text: user.status.rawValue,
                        backgroundColor: statusColor(for: user.status),
                        foregroundColor: .white
                    )
                }
            }
            .offset(y: 30)
        }
        .frame(height: 280)
    }
    
    private func statusColor(for status: UserStatus) -> Color {
        switch status {
        case .available: return .statusGreen
        case .onSite: return .statusBlue
        case .onBreak: return .statusYellow
        case .offDuty: return .statusRed
        }
    }
}

#Preview {
    ProfileView()
}
