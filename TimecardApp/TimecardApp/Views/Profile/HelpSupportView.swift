import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var showingChat = false
    
    let faqItems = [
        FAQItem(question: "How do I submit a timecard?", answer: "Navigate to the Timecard tab, fill in your time details, and tap 'Submit Entry'."),
        FAQItem(question: "How do I request time off?", answer: "Go to Profile > Request Time Off and fill out the request form."),
        FAQItem(question: "Why was my timecard rejected?", answer: "Check your notifications for details. Common reasons include missing information or overlapping entries."),
        FAQItem(question: "How do I update my signature?", answer: "Go to Profile and tap on the Signature card to add or update your signature."),
        FAQItem(question: "Can I edit a submitted entry?", answer: "Only draft and pending entries can be edited. Contact your supervisor for approved entries.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        // Search Bar
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.textTertiary)
                            
                            TextField("Search help topics...", text: $searchText)
                                .font(AppFont.body)
                        }
                        .padding(AppSpacing.sm)
                        .background(Color.backgroundCard)
                        .cornerRadius(AppRadius.medium)
                        .softShadow()
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Contact Support Card
                        SectionCard {
                            VStack(spacing: AppSpacing.md) {
                                Image(systemName: "headphones.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.primaryOrange)
                                
                                Text("Need Help?")
                                    .font(AppFont.title3)
                                    .foregroundColor(.textPrimary)
                                
                                Text("Our support team is here to assist you with any questions or issues.")
                                    .font(AppFont.subheadline)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                                
                                PrimaryButton(title: "Chat with Support") {
                                    showingChat = true
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // Quick Actions
                        SectionCard(padding: 0) {
                            VStack(spacing: 0) {
                                MenuRow(
                                    icon: "phone.fill",
                                    title: "Call Support",
                                    subtitle: "+1 (800) 555-0123",
                                    action: {
                                        // Handle call
                                    }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "envelope.fill",
                                    title: "Email Support",
                                    subtitle: "support@linarc.com",
                                    action: {
                                        // Handle email
                                    }
                                )
                                .padding(.horizontal, AppSpacing.md)
                                
                                MenuRow(
                                    icon: "doc.text.fill",
                                    title: "Documentation",
                                    subtitle: "View user guide",
                                    showDivider: false,
                                    action: {
                                        // Handle docs
                                    }
                                )
                                .padding(.horizontal, AppSpacing.md)
                            }
                            .padding(.vertical, AppSpacing.xs)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        
                        // FAQ Section
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("FREQUENTLY ASKED QUESTIONS")
                                .sectionHeaderStyle()
                                .padding(.horizontal, AppSpacing.md)
                            
                            SectionCard(padding: 0) {
                                VStack(spacing: 0) {
                                    ForEach(faqItems.indices, id: \.self) { index in
                                        FAQRow(
                                            item: faqItems[index],
                                            showDivider: index < faqItems.count - 1
                                        )
                                        .padding(.horizontal, AppSpacing.md)
                                    }
                                }
                                .padding(.vertical, AppSpacing.xs)
                            }
                            .padding(.horizontal, AppSpacing.md)
                        }
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Help & Support")
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
        .sheet(isPresented: $showingChat) {
            ChatSupportView()
        }
    }
}

// MARK: - FAQ Item
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

// MARK: - FAQ Row
struct FAQRow: View {
    let item: FAQItem
    var showDivider: Bool = true
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(item.question)
                        .font(AppFont.body)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
                .padding(.vertical, AppSpacing.sm)
            }
            
            if isExpanded {
                Text(item.answer)
                    .font(AppFont.subheadline)
                    .foregroundColor(.textSecondary)
                    .padding(.bottom, AppSpacing.sm)
            }
            
            if showDivider {
                Divider()
            }
        }
    }
}

// MARK: - Chat Support View
struct ChatSupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi, how can we help you?", isFromUser: false, timestamp: Date())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat Header
                VStack(spacing: AppSpacing.xs) {
                    Image(systemName: "triangle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.primaryOrange)
                    
                    Text("LINARC")
                        .font(AppFont.title3)
                        .foregroundColor(.textPrimary)
                    
                    Text("Support Team")
                        .font(AppFont.caption)
                        .foregroundColor(.textSecondary)
                }
                .padding(.vertical, AppSpacing.md)
                .frame(maxWidth: .infinity)
                .background(Color.backgroundCard)
                
                Divider()
                
                // Messages
                ScrollView {
                    LazyVStack(spacing: AppSpacing.md) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding(AppSpacing.md)
                }
                
                // Input Field
                HStack(spacing: AppSpacing.sm) {
                    TextField("Type a message...", text: $messageText)
                        .font(AppFont.body)
                        .padding(AppSpacing.sm)
                        .background(Color.backgroundGray)
                        .cornerRadius(AppRadius.pill)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.primaryOrange)
                            .clipShape(Circle())
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding(AppSpacing.md)
                .background(Color.backgroundCard)
            }
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
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        messages.append(ChatMessage(text: messageText, isFromUser: true, timestamp: Date()))
        messageText = ""
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            messages.append(ChatMessage(
                text: "Thank you for reaching out! A support agent will respond shortly.",
                isFromUser: false,
                timestamp: Date()
            ))
        }
    }
}

// MARK: - Chat Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let timestamp: Date
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            
            Text(message.text)
                .font(AppFont.body)
                .foregroundColor(message.isFromUser ? .white : .textPrimary)
                .padding(AppSpacing.sm)
                .background(message.isFromUser ? Color.primaryOrange : Color.backgroundGray)
                .cornerRadius(AppRadius.medium)
            
            if !message.isFromUser {
                Spacer()
            }
        }
    }
}

#Preview {
    HelpSupportView()
}
