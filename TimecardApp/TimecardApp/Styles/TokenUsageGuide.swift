import SwiftUI

// MARK: - Design Token Usage Guide
/// This file demonstrates how to use design tokens throughout the app.
/// Tokens ensure consistency and make design system updates easier.

// MARK: - Example Usage
struct TokenUsageExamples: View {
    var body: some View {
        ScrollView {
            VStack(spacing: SpacingTokens.lg) {
                
                // MARK: Colors
                Group {
                    Text("Brand Colors")
                        .font(TypographyTokens.Styles.headline)
                        .foregroundColor(ColorTokens.Light.textPrimary)
                    
                    HStack(spacing: SpacingTokens.sm) {
                        ColorSwatch(color: ColorTokens.Brand.primary, name: "Primary")
                        ColorSwatch(color: ColorTokens.Brand.secondary, name: "Secondary")
                        ColorSwatch(color: ColorTokens.Semantic.success, name: "Success")
                        ColorSwatch(color: ColorTokens.Semantic.error, name: "Error")
                    }
                }
                
                // MARK: Typography
                Group {
                    Text("Typography")
                        .font(TypographyTokens.Styles.headline)
                    
                    VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                        Text("Large Title").font(TypographyTokens.Styles.largeTitle)
                        Text("Title 1").font(TypographyTokens.Styles.title1)
                        Text("Title 2").font(TypographyTokens.Styles.title2)
                        Text("Headline").font(TypographyTokens.Styles.headline)
                        Text("Body").font(TypographyTokens.Styles.body)
                        Text("Caption").font(TypographyTokens.Styles.caption1)
                    }
                }
                
                // MARK: Spacing
                Group {
                    Text("Spacing")
                        .font(TypographyTokens.Styles.headline)
                    
                    HStack(spacing: SpacingTokens.xs) {
                        SpacingSwatch(size: SpacingTokens.xs, name: "xs")
                        SpacingSwatch(size: SpacingTokens.sm, name: "sm")
                        SpacingSwatch(size: SpacingTokens.md, name: "md")
                        SpacingSwatch(size: SpacingTokens.lg, name: "lg")
                        SpacingSwatch(size: SpacingTokens.xl, name: "xl")
                    }
                }
                
                // MARK: Radius
                Group {
                    Text("Border Radius")
                        .font(TypographyTokens.Styles.headline)
                    
                    HStack(spacing: SpacingTokens.sm) {
                        RadiusSwatch(radius: RadiusTokens.sm, name: "sm")
                        RadiusSwatch(radius: RadiusTokens.md, name: "md")
                        RadiusSwatch(radius: RadiusTokens.lg, name: "lg")
                        RadiusSwatch(radius: RadiusTokens.full, name: "full")
                    }
                }
                
                // MARK: Shadows
                Group {
                    Text("Shadows")
                        .font(TypographyTokens.Styles.headline)
                    
                    HStack(spacing: SpacingTokens.md) {
                        ShadowSwatch(shadow: ShadowTokens.sm, name: "sm")
                        ShadowSwatch(shadow: ShadowTokens.md, name: "md")
                        ShadowSwatch(shadow: ShadowTokens.lg, name: "lg")
                    }
                }
                
                // MARK: Components
                Group {
                    Text("Component Sizes")
                        .font(TypographyTokens.Styles.headline)
                    
                    VStack(spacing: SpacingTokens.sm) {
                        // Buttons
                        Text("Button: Small")
                            .frame(height: ComponentTokens.Button.heightSmall)
                            .frame(maxWidth: .infinity)
                            .background(ColorTokens.Brand.primary)
                            .foregroundColor(.white)
                            .cornerRadius(RadiusTokens.button)
                        
                        Text("Button: Medium")
                            .frame(height: ComponentTokens.Button.heightMedium)
                            .frame(maxWidth: .infinity)
                            .background(ColorTokens.Brand.primary)
                            .foregroundColor(.white)
                            .cornerRadius(RadiusTokens.button)
                        
                        Text("Button: Large")
                            .frame(height: ComponentTokens.Button.heightLarge)
                            .frame(maxWidth: .infinity)
                            .background(ColorTokens.Brand.primary)
                            .foregroundColor(.white)
                            .cornerRadius(RadiusTokens.button)
                    }
                    
                    // Avatars
                    HStack(spacing: SpacingTokens.md) {
                        Circle()
                            .fill(ColorTokens.Brand.primary)
                            .frame(width: ComponentTokens.Avatar.sizeSM, height: ComponentTokens.Avatar.sizeSM)
                        Circle()
                            .fill(ColorTokens.Brand.primary)
                            .frame(width: ComponentTokens.Avatar.sizeMD, height: ComponentTokens.Avatar.sizeMD)
                        Circle()
                            .fill(ColorTokens.Brand.primary)
                            .frame(width: ComponentTokens.Avatar.sizeLG, height: ComponentTokens.Avatar.sizeLG)
                        Circle()
                            .fill(ColorTokens.Brand.primary)
                            .frame(width: ComponentTokens.Avatar.sizeXL, height: ComponentTokens.Avatar.sizeXL)
                    }
                }
                
                // MARK: Card with Tokens
                Group {
                    Text("Card Example")
                        .font(TypographyTokens.Styles.headline)
                    
                    VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                        Text("Card Title")
                            .font(TypographyTokens.Styles.headline)
                            .foregroundColor(ColorTokens.Light.textPrimary)
                        
                        Text("This card uses design tokens for consistent styling.")
                            .font(TypographyTokens.Styles.body)
                            .foregroundColor(ColorTokens.Light.textSecondary)
                    }
                    .tokenCard()
                }
                
                // MARK: Pills
                Group {
                    Text("Status Pills")
                        .font(TypographyTokens.Styles.headline)
                    
                    HStack(spacing: SpacingTokens.sm) {
                        Text("Active").tokenPill()
                        Text("Pending").tokenPill(backgroundColor: ColorTokens.Semantic.warning)
                        Text("Approved").tokenPill(backgroundColor: ColorTokens.Semantic.success)
                        Text("Rejected").tokenPill(backgroundColor: ColorTokens.Semantic.error)
                    }
                }
            }
            .padding(SpacingTokens.screenPadding)
        }
        .background(ColorTokens.Light.backgroundPrimary)
    }
}

// MARK: - Swatch Components
struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingTokens.xxs) {
            RoundedRectangle(cornerRadius: RadiusTokens.sm)
                .fill(color)
                .frame(width: 50, height: 50)
            Text(name)
                .font(TypographyTokens.Styles.caption2)
                .foregroundColor(ColorTokens.Light.textSecondary)
        }
    }
}

struct SpacingSwatch: View {
    let size: CGFloat
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingTokens.xxs) {
            RoundedRectangle(cornerRadius: RadiusTokens.xs)
                .fill(ColorTokens.Brand.primary)
                .frame(width: size, height: size)
            Text(name)
                .font(TypographyTokens.Styles.caption2)
                .foregroundColor(ColorTokens.Light.textSecondary)
        }
    }
}

struct RadiusSwatch: View {
    let radius: CGFloat
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingTokens.xxs) {
            RoundedRectangle(cornerRadius: radius)
                .fill(ColorTokens.Brand.primary)
                .frame(width: 50, height: 50)
            Text(name)
                .font(TypographyTokens.Styles.caption2)
                .foregroundColor(ColorTokens.Light.textSecondary)
        }
    }
}

struct ShadowSwatch: View {
    let shadow: ShadowTokens.Shadow
    let name: String
    
    var body: some View {
        VStack(spacing: SpacingTokens.xs) {
            RoundedRectangle(cornerRadius: RadiusTokens.md)
                .fill(Color.white)
                .frame(width: 60, height: 60)
                .tokenShadow(shadow)
            Text(name)
                .font(TypographyTokens.Styles.caption2)
                .foregroundColor(ColorTokens.Light.textSecondary)
        }
    }
}

// MARK: - Quick Reference
/*
 
 ┌─────────────────────────────────────────────────────────────┐
 │                    DESIGN TOKENS QUICK REFERENCE            │
 └─────────────────────────────────────────────────────────────┘
 
 COLORS:
 ├── ColorTokens.Brand.primary          // Main orange #F5A623
 ├── ColorTokens.Brand.secondary        // Navy #1F293D
 ├── ColorTokens.Semantic.success       // Green
 ├── ColorTokens.Semantic.warning       // Yellow
 ├── ColorTokens.Semantic.error         // Red
 ├── ColorTokens.Semantic.info          // Blue
 ├── ColorTokens.Light.backgroundPrimary
 ├── ColorTokens.Light.textPrimary
 └── ColorTokens.Dark.* (for dark theme)
 
 TYPOGRAPHY:
 ├── TypographyTokens.Styles.largeTitle
 ├── TypographyTokens.Styles.title1/2/3
 ├── TypographyTokens.Styles.headline
 ├── TypographyTokens.Styles.body
 ├── TypographyTokens.Styles.caption1/2
 └── TypographyTokens.Size.sm/md/lg/xl
 
 SPACING:
 ├── SpacingTokens.xs   (8pt)
 ├── SpacingTokens.sm   (12pt)
 ├── SpacingTokens.md   (16pt)
 ├── SpacingTokens.lg   (20pt)
 ├── SpacingTokens.xl   (24pt)
 └── SpacingTokens.xxl  (32pt)
 
 RADIUS:
 ├── RadiusTokens.sm    (8pt)
 ├── RadiusTokens.md    (12pt)
 ├── RadiusTokens.lg    (16pt)
 ├── RadiusTokens.card  (16pt)
 └── RadiusTokens.pill  (full)
 
 SHADOWS:
 ├── ShadowTokens.sm
 ├── ShadowTokens.md
 ├── ShadowTokens.lg
 └── ShadowTokens.card
 
 COMPONENTS:
 ├── ComponentTokens.Button.heightSmall/Medium/Large
 ├── ComponentTokens.Avatar.sizeSM/MD/LG/XL
 ├── ComponentTokens.Card.padding/radius
 └── ComponentTokens.Input.height
 
 VIEW MODIFIERS:
 ├── .tokenShadow(ShadowTokens.md)
 ├── .tokenCard()
 └── .tokenPill()
 
 */

#Preview {
    TokenUsageExamples()
}
