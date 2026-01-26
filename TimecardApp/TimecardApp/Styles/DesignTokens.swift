import SwiftUI

// MARK: - Design Tokens
/// Central source of truth for all design values in the app.
/// Use these tokens instead of hardcoded values to maintain consistency.

// MARK: - Color Tokens
struct ColorTokens {
    
    // MARK: Brand Colors
    struct Brand {
        static let primary = Color(hex: "F5A623")      // Orange
        static let primaryDark = Color(hex: "D4891C") // Darker orange for pressed states
        static let primaryLight = Color(hex: "FFBD4F") // Lighter orange for backgrounds
        static let secondary = Color(hex: "1F293D")    // Navy
        static let secondaryLight = Color(hex: "2A3651")
        static let accent = Color(hex: "F5A623")
    }
    
    // MARK: Semantic Colors
    struct Semantic {
        static let success = Color(hex: "34C759")      // Green
        static let successLight = Color(hex: "D4EDDA")
        static let warning = Color(hex: "FCCC14")      // Yellow
        static let warningLight = Color(hex: "FFF3CD")
        static let error = Color(hex: "F44336")        // Red
        static let errorLight = Color(hex: "F8D7DA")
        static let info = Color(hex: "339AD8")         // Blue
        static let infoLight = Color(hex: "D1ECF1")
    }
    
    // MARK: Light Theme
    struct Light {
        // Backgrounds
        static let backgroundPrimary = Color(hex: "F5F7FA")
        static let backgroundSecondary = Color(hex: "FFFFFF")
        static let backgroundTertiary = Color(hex: "F0F0F5")
        static let backgroundCard = Color(hex: "FFFFFF")
        static let backgroundInput = Color(hex: "F0F0F5")
        static let backgroundOverlay = Color.black.opacity(0.4)
        
        // Text
        static let textPrimary = Color(hex: "21262F")
        static let textSecondary = Color(hex: "737885")
        static let textTertiary = Color(hex: "A6ABB5")
        static let textDisabled = Color(hex: "C4C8CF")
        static let textInverse = Color(hex: "FFFFFF")
        static let textOnBrand = Color(hex: "FFFFFF")
        
        // Borders
        static let borderDefault = Color(hex: "E6E8EC")
        static let borderStrong = Color(hex: "D2D5DB")
        static let borderFocus = Color(hex: "F5A623")
        
        // Surfaces
        static let surfaceDefault = Color(hex: "FFFFFF")
        static let surfaceHover = Color(hex: "F5F7FA")
        static let surfacePressed = Color(hex: "E6E8EC")
        static let surfaceSelected = Color(hex: "FFF5E5")
    }
    
    // MARK: Dark Theme
    struct Dark {
        // Backgrounds
        static let backgroundPrimary = Color(hex: "000000")
        static let backgroundSecondary = Color(hex: "1C1C1F")
        static let backgroundTertiary = Color(hex: "2C2C2E")
        static let backgroundCard = Color(hex: "1C1C1F")
        static let backgroundInput = Color(hex: "2C2C2E")
        static let backgroundOverlay = Color.black.opacity(0.6)
        
        // Text
        static let textPrimary = Color(hex: "FFFFFF")
        static let textSecondary = Color(hex: "ABABAB")
        static let textTertiary = Color(hex: "6E6E73")
        static let textDisabled = Color(hex: "48484A")
        static let textInverse = Color(hex: "000000")
        static let textOnBrand = Color(hex: "FFFFFF")
        
        // Borders
        static let borderDefault = Color(hex: "38383A")
        static let borderStrong = Color(hex: "48484A")
        static let borderFocus = Color(hex: "F5A623")
        
        // Surfaces
        static let surfaceDefault = Color(hex: "1C1C1F")
        static let surfaceHover = Color(hex: "2C2C2E")
        static let surfacePressed = Color(hex: "3A3A3C")
        static let surfaceSelected = Color(hex: "3D2E1A")
    }
}

// MARK: - Typography Tokens
struct TypographyTokens {
    
    // MARK: Font Sizes
    struct Size {
        static let xxxl: CGFloat = 34    // Large titles
        static let xxl: CGFloat = 28     // Titles
        static let xl: CGFloat = 22      // Title 2
        static let lg: CGFloat = 20      // Title 3
        static let md: CGFloat = 17      // Body
        static let sm: CGFloat = 15      // Callout
        static let xs: CGFloat = 13      // Footnote
        static let xxs: CGFloat = 12     // Caption
        static let xxxs: CGFloat = 11    // Caption 2
    }
    
    // MARK: Font Weights
    struct Weight {
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
        static let heavy = Font.Weight.heavy
    }
    
    // MARK: Line Heights
    struct LineHeight {
        static let tight: CGFloat = 1.1
        static let normal: CGFloat = 1.3
        static let relaxed: CGFloat = 1.5
        static let loose: CGFloat = 1.7
    }
    
    // MARK: Letter Spacing
    struct LetterSpacing {
        static let tight: CGFloat = -0.5
        static let normal: CGFloat = 0
        static let wide: CGFloat = 0.5
        static let wider: CGFloat = 1.0
        static let widest: CGFloat = 2.0
    }
    
    // MARK: Predefined Text Styles
    struct Styles {
        static let largeTitle = Font.system(size: Size.xxxl, weight: .bold)
        static let title1 = Font.system(size: Size.xxl, weight: .bold)
        static let title2 = Font.system(size: Size.xl, weight: .semibold)
        static let title3 = Font.system(size: Size.lg, weight: .semibold)
        static let headline = Font.system(size: Size.md, weight: .semibold)
        static let body = Font.system(size: Size.md, weight: .regular)
        static let bodyBold = Font.system(size: Size.md, weight: .semibold)
        static let callout = Font.system(size: Size.sm, weight: .regular)
        static let subheadline = Font.system(size: Size.sm, weight: .medium)
        static let footnote = Font.system(size: Size.xs, weight: .regular)
        static let caption1 = Font.system(size: Size.xxs, weight: .regular)
        static let caption2 = Font.system(size: Size.xxxs, weight: .medium)
        static let overline = Font.system(size: Size.xxxs, weight: .semibold)
    }
}

// MARK: - Spacing Tokens
struct SpacingTokens {
    static let none: CGFloat = 0
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
    static let xxxxl: CGFloat = 48
    static let xxxxxl: CGFloat = 64
    
    // Semantic spacing
    static let componentPadding: CGFloat = md
    static let cardPadding: CGFloat = md
    static let sectionSpacing: CGFloat = lg
    static let screenPadding: CGFloat = md
    static let listItemSpacing: CGFloat = sm
    static let inlineSpacing: CGFloat = xs
}

// MARK: - Border Radius Tokens
struct RadiusTokens {
    static let none: CGFloat = 0
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let full: CGFloat = 9999  // Pill shape
    
    // Semantic radius
    static let button: CGFloat = md
    static let card: CGFloat = lg
    static let input: CGFloat = sm
    static let pill: CGFloat = full
    static let avatar: CGFloat = full
    static let modal: CGFloat = xl
}

// MARK: - Shadow Tokens
struct ShadowTokens {
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
    
    static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)
    
    static let xs = Shadow(
        color: Color.black.opacity(0.04),
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let sm = Shadow(
        color: Color.black.opacity(0.06),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let md = Shadow(
        color: Color.black.opacity(0.08),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let lg = Shadow(
        color: Color.black.opacity(0.10),
        radius: 12,
        x: 0,
        y: 6
    )
    
    static let xl = Shadow(
        color: Color.black.opacity(0.12),
        radius: 16,
        x: 0,
        y: 8
    )
    
    static let xxl = Shadow(
        color: Color.black.opacity(0.16),
        radius: 24,
        x: 0,
        y: 12
    )
    
    // Semantic shadows
    static let card = md
    static let button = sm
    static let dropdown = lg
    static let modal = xl
    static let toast = md
}

// MARK: - Border Tokens
struct BorderTokens {
    static let none: CGFloat = 0
    static let thin: CGFloat = 0.5
    static let regular: CGFloat = 1
    static let medium: CGFloat = 1.5
    static let thick: CGFloat = 2
    static let heavy: CGFloat = 3
}

// MARK: - Icon Tokens
struct IconTokens {
    
    struct Size {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 28
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let xxxxl: CGFloat = 48
    }
    
    struct Weight {
        static let light = Font.Weight.light
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
    }
}

// MARK: - Animation Tokens
struct AnimationTokens {
    
    struct Duration {
        static let instant: Double = 0.1
        static let fast: Double = 0.15
        static let normal: Double = 0.25
        static let slow: Double = 0.35
        static let slower: Double = 0.5
        static let slowest: Double = 0.7
    }
    
    struct Curve {
        static let easeIn = Animation.easeIn
        static let easeOut = Animation.easeOut
        static let easeInOut = Animation.easeInOut
        static let linear = Animation.linear
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    }
    
    // Predefined animations
    static let fadeIn = Animation.easeOut(duration: Duration.fast)
    static let fadeOut = Animation.easeIn(duration: Duration.fast)
    static let slideIn = Animation.easeOut(duration: Duration.normal)
    static let slideOut = Animation.easeIn(duration: Duration.normal)
    static let scale = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let buttonPress = Animation.easeInOut(duration: Duration.instant)
}

// MARK: - Opacity Tokens
struct OpacityTokens {
    static let transparent: Double = 0
    static let subtle: Double = 0.05
    static let light: Double = 0.1
    static let medium: Double = 0.3
    static let high: Double = 0.6
    static let heavy: Double = 0.8
    static let opaque: Double = 1.0
    
    // Semantic
    static let disabled: Double = 0.4
    static let hover: Double = 0.08
    static let pressed: Double = 0.12
    static let overlay: Double = 0.5
    static let scrim: Double = 0.4
}

// MARK: - Z-Index Tokens
struct ZIndexTokens {
    static let base: Double = 0
    static let raised: Double = 1
    static let dropdown: Double = 100
    static let sticky: Double = 200
    static let overlay: Double = 300
    static let modal: Double = 400
    static let toast: Double = 500
    static let tooltip: Double = 600
}

// MARK: - Component Size Tokens
struct ComponentTokens {
    
    struct Button {
        static let heightSmall: CGFloat = 32
        static let heightMedium: CGFloat = 44
        static let heightLarge: CGFloat = 52
        static let minWidth: CGFloat = 64
        static let iconSpacing: CGFloat = SpacingTokens.xs
    }
    
    struct Input {
        static let height: CGFloat = 44
        static let heightLarge: CGFloat = 52
        static let paddingHorizontal: CGFloat = SpacingTokens.sm
        static let iconSize: CGFloat = IconTokens.Size.md
    }
    
    struct Avatar {
        static let sizeXS: CGFloat = 24
        static let sizeSM: CGFloat = 32
        static let sizeMD: CGFloat = 40
        static let sizeLG: CGFloat = 56
        static let sizeXL: CGFloat = 80
        static let sizeXXL: CGFloat = 100
        static let sizeXXXL: CGFloat = 120
    }
    
    struct Card {
        static let padding: CGFloat = SpacingTokens.md
        static let radius: CGFloat = RadiusTokens.lg
        static let borderWidth: CGFloat = BorderTokens.none
    }
    
    struct TabBar {
        static let height: CGFloat = 49
        static let iconSize: CGFloat = IconTokens.Size.lg
    }
    
    struct NavigationBar {
        static let height: CGFloat = 44
        static let largeTitleHeight: CGFloat = 96
    }
    
    struct StatusPill {
        static let height: CGFloat = 24
        static let paddingHorizontal: CGFloat = SpacingTokens.sm
        static let paddingVertical: CGFloat = SpacingTokens.xxs
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions for Tokens
extension View {
    
    /// Apply shadow using shadow tokens
    func tokenShadow(_ shadow: ShadowTokens.Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
    
    /// Apply card style using tokens
    func tokenCard(
        backgroundColor: Color = ColorTokens.Light.backgroundCard,
        padding: CGFloat = ComponentTokens.Card.padding,
        radius: CGFloat = ComponentTokens.Card.radius,
        shadow: ShadowTokens.Shadow = ShadowTokens.card
    ) -> some View {
        self
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(radius)
            .tokenShadow(shadow)
    }
    
    /// Apply pill style using tokens
    func tokenPill(
        backgroundColor: Color = ColorTokens.Brand.primary,
        foregroundColor: Color = ColorTokens.Light.textOnBrand
    ) -> some View {
        self
            .font(TypographyTokens.Styles.caption2)
            .padding(.horizontal, ComponentTokens.StatusPill.paddingHorizontal)
            .padding(.vertical, ComponentTokens.StatusPill.paddingVertical)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(RadiusTokens.pill)
    }
}

// MARK: - Theme Protocol
protocol ThemeColors {
    var backgroundPrimary: Color { get }
    var backgroundSecondary: Color { get }
    var backgroundCard: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textTertiary: Color { get }
    var borderDefault: Color { get }
}

struct LightTheme: ThemeColors {
    var backgroundPrimary: Color { ColorTokens.Light.backgroundPrimary }
    var backgroundSecondary: Color { ColorTokens.Light.backgroundSecondary }
    var backgroundCard: Color { ColorTokens.Light.backgroundCard }
    var textPrimary: Color { ColorTokens.Light.textPrimary }
    var textSecondary: Color { ColorTokens.Light.textSecondary }
    var textTertiary: Color { ColorTokens.Light.textTertiary }
    var borderDefault: Color { ColorTokens.Light.borderDefault }
}

struct DarkTheme: ThemeColors {
    var backgroundPrimary: Color { ColorTokens.Dark.backgroundPrimary }
    var backgroundSecondary: Color { ColorTokens.Dark.backgroundSecondary }
    var backgroundCard: Color { ColorTokens.Dark.backgroundCard }
    var textPrimary: Color { ColorTokens.Dark.textPrimary }
    var textSecondary: Color { ColorTokens.Dark.textSecondary }
    var textTertiary: Color { ColorTokens.Dark.textTertiary }
    var borderDefault: Color { ColorTokens.Dark.borderDefault }
}

// MARK: - Theme Environment Key
struct ThemeKey: EnvironmentKey {
    static let defaultValue: ThemeColors = LightTheme()
}

extension EnvironmentValues {
    var theme: ThemeColors {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
