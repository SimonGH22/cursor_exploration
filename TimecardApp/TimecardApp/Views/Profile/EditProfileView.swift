import SwiftUI

struct EditProfileView: View {
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Avatar Section
                        VStack(spacing: AppSpacing.md) {
                            ProfileAvatar(
                                initials: "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased(),
                                size: 100,
                                backgroundColor: .primaryOrange
                            )
                            
                            Button(action: {
                                // Handle photo change
                            }) {
                                Text("Change Photo")
                                    .font(AppFont.subheadline)
                                    .foregroundColor(.primaryOrange)
                            }
                        }
                        .padding(.top, AppSpacing.md)
                        
                        // Personal Information
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Personal Information")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                FormField(
                                    label: "First Name",
                                    text: $firstName,
                                    placeholder: "Enter first name"
                                )
                                
                                FormField(
                                    label: "Last Name",
                                    text: $lastName,
                                    placeholder: "Enter last name"
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Contact Information
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Contact Information")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                FormField(
                                    label: "Email",
                                    text: $email,
                                    placeholder: "Enter email",
                                    keyboardType: .emailAddress
                                )
                                
                                FormField(
                                    label: "Phone",
                                    text: $phone,
                                    placeholder: "Enter phone number",
                                    keyboardType: .phonePad
                                )
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Role Information (Read Only)
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                Text("Role Information")
                                    .font(AppFont.headline)
                                    .foregroundColor(.textPrimary)
                                
                                InfoRow(label: "Role", value: user.role)
                                Divider()
                                InfoRow(label: "Status", value: user.status.rawValue)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Save Button
                        PrimaryButton(title: "Save Changes", isLoading: isSaving) {
                            saveChanges()
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        SecondaryButton(title: "Cancel") {
                            dismiss()
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationTitle("Edit Profile")
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
        .onAppear {
            firstName = user.firstName
            lastName = user.lastName
            email = user.email
            phone = user.phone
        }
    }
    
    private func saveChanges() {
        isSaving = true
        
        // Simulate save delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            user.firstName = firstName
            user.lastName = lastName
            user.email = email
            user.phone = phone
            isSaving = false
            dismiss()
        }
    }
}

#Preview {
    EditProfileView(user: .constant(User.sample))
}
