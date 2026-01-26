import SwiftUI

struct SignatureView: View {
    @Environment(\.dismiss) var dismiss
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundLight
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.md) {
                    // Instructions
                    SectionCard {
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "signature")
                                .font(.system(size: 32))
                                .foregroundColor(.primaryOrange)
                            
                            Text("Draw Your Signature")
                                .font(AppFont.headline)
                                .foregroundColor(.textPrimary)
                            
                            Text("Use your finger to sign in the box below")
                                .font(AppFont.subheadline)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Signature Canvas
                    SectionCard(padding: 0) {
                        VStack(spacing: 0) {
                            ZStack {
                                Color.white
                                
                                // Baseline
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .fill(Color.borderLight)
                                        .frame(height: 1)
                                        .padding(.horizontal, AppSpacing.md)
                                        .padding(.bottom, 40)
                                }
                                
                                // Signature lines
                                Canvas { context, size in
                                    for line in lines {
                                        var path = Path()
                                        if let firstPoint = line.first {
                                            path.move(to: firstPoint)
                                            for point in line.dropFirst() {
                                                path.addLine(to: point)
                                            }
                                        }
                                        context.stroke(path, with: .color(.textPrimary), lineWidth: 2)
                                    }
                                    
                                    // Current line being drawn
                                    var currentPath = Path()
                                    if let firstPoint = currentLine.first {
                                        currentPath.move(to: firstPoint)
                                        for point in currentLine.dropFirst() {
                                            currentPath.addLine(to: point)
                                        }
                                    }
                                    context.stroke(currentPath, with: .color(.textPrimary), lineWidth: 2)
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            currentLine.append(value.location)
                                        }
                                        .onEnded { _ in
                                            lines.append(currentLine)
                                            currentLine = []
                                        }
                                )
                                
                                // X mark for signature line
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("✕")
                                            .font(AppFont.title3)
                                            .foregroundColor(.textTertiary)
                                            .padding(.leading, AppSpacing.md)
                                        Spacer()
                                    }
                                    .padding(.bottom, 45)
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(AppRadius.medium)
                            
                            Divider()
                            
                            // Clear Button
                            Button(action: clearSignature) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Clear")
                                }
                                .font(AppFont.subheadline)
                                .foregroundColor(.statusRed)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppSpacing.sm)
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: AppSpacing.sm) {
                        PrimaryButton(
                            title: "Save Signature",
                            isLoading: isSaving,
                            isDisabled: lines.isEmpty
                        ) {
                            saveSignature()
                        }
                        
                        SecondaryButton(title: "Cancel") {
                            dismiss()
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.md)
                }
            }
            .navigationTitle("Signature")
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
    
    private func clearSignature() {
        withAnimation {
            lines.removeAll()
            currentLine.removeAll()
        }
    }
    
    private func saveSignature() {
        isSaving = true
        
        // Simulate save
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isSaving = false
            dismiss()
        }
    }
}

#Preview {
    SignatureView()
}
