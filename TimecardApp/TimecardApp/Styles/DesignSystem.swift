import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary Colors
    static let primaryOrange = Color(red: 0.96, green: 0.65, blue: 0.14) // #F5A623
    static let primaryDark = Color(red: 0.13, green: 0.15, blue: 0.19) // #21262F
    static let primaryNavy = Color(red: 0.12, green: 0.16, blue: 0.24) // #1F293D
    
    // Background Colors
    static let backgroundLight = Color(red: 0.96, green: 0.97, blue: 0.98) // #F5F7FA
    static let backgroundCard = Color.white
    static let backgroundGray = Color(red: 0.94, green: 0.94, blue: 0.96) // #F0F0F5
    
    // Text Colors
    static let textPrimary = Color(red: 0.13, green: 0.15, blue: 0.19)
    static let textSecondary = Color(red: 0.45, green: 0.48, blue: 0.53)
    static let textTertiary = Color(red: 0.65, green: 0.67, blue: 0.71)
    static let textOnOrange = Color.white
    
    // Status Colors
    static let statusGreen = Color(red: 0.20, green: 0.78, blue: 0.35)
    static let statusRed = Color(red: 0.95, green: 0.26, blue: 0.21)
    static let statusBlue = Color(red: 0.20, green: 0.60, blue: 0.86)
    static let statusYellow = Color(red: 0.99, green: 0.80, blue: 0.20)
    
    // Border Colors
    static let borderLight = Color(red: 0.90, green: 0.91, blue: 0.93)
    static let borderMedium = Color(red: 0.82, green: 0.84, blue: 0.87)
}

// MARK: - Typography
struct AppFont {
    static func bold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold)
    }
    
    static func semibold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium)
    }
    
    static func regular(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular)
    }
    
    // Predefined sizes
    static let largeTitle = bold(28)
    static let title = bold(22)
    static let title2 = semibold(20)
    static let title3 = semibold(18)
    static let headline = semibold(16)
    static let body = regular(16)
    static let callout = regular(15)
    static let subheadline = medium(14)
    static let footnote = regular(13)
    static let caption = regular(12)
    static let caption2 = medium(11)
}

// MARK: - Shadows
extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    func softShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    func subtleShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 1)
    }
}

// MARK: - Corner Radius
struct AppRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 20
    static let pill: CGFloat = 50
}

// MARK: - Spacing
struct AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

// MARK: - View Modifiers
struct CardStyle: ViewModifier {
    var padding: CGFloat = AppSpacing.md
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.backgroundCard)
            .cornerRadius(AppRadius.large)
            .cardShadow()
    }
}

struct PillStyle: ViewModifier {
    var backgroundColor: Color = .primaryOrange
    var foregroundColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(AppFont.caption2)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(AppRadius.pill)
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppFont.subheadline)
            .foregroundColor(.textSecondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

extension View {
    func cardStyle(padding: CGFloat = AppSpacing.md) -> some View {
        modifier(CardStyle(padding: padding))
    }
    
    func pillStyle(backgroundColor: Color = .primaryOrange, foregroundColor: Color = .white) -> some View {
        modifier(PillStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
    
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyle())
    }
}
