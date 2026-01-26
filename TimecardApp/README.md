# TimecardApp - iOS SwiftUI

A modern iOS timecard application built with SwiftUI, featuring a profile-style design with custom headers, card sections, rounded pills, and soft shadows.

## Features

### Tab Bar Navigation
- **Timecard** - Clock in/out and create time entries
- **Entries** - View and manage all time entries
- **Summary** - Weekly/monthly time summaries with charts
- **Profile** - User profile and settings

### Profile Screen
- Custom orange header with user avatar (initials)
- User name and role/status badges (rounded pills)
- Menu sections:
  - My Profile (edit personal information)
  - Request Time Off
  - Driving and Operator Licenses
  - Help & Support
  - Notifications
  - Gallery
- Signature card with drawing canvas
- Geolocation toggle
- Logout option

### Timecard Entry
- Clock in/out status card with live timer
- Date picker for entry date
- Time pickers for clock in/out
- Break duration slider
- Project and task selection
- Notes field
- Submit/Save as Draft actions

### Time Entries List
- Search bar with filter pills (All, Pending, Submitted, Approved)
- Stats summary card (total hours, entry count, pending)
- Card-based entry list with status pills
- Entry detail view with full information

### Summary Dashboard
- Period selector (This Week, Last Week, This Month, Last Month)
- Total hours hero card with gradient
- Regular hours and overtime breakdown
- Entry status summary (days worked, pending, approved)
- Weekly bar chart visualization
- Quick actions (Export, Print, Share)

### Supporting Screens
- **Edit Profile** - Update personal and contact information
- **Time Off Request** - Submit vacation/sick/personal leave requests
- **Help & Support** - FAQ, contact support, live chat
- **Notifications** - Manage alerts and view notification history
- **Signature** - Draw and save digital signature

## Design System

### Colors
- Primary Orange: `#F5A623` - Main accent color
- Primary Navy: `#1F293D` - Secondary accent
- Background Light: `#F5F7FA` - Main background
- Status colors: Green, Blue, Yellow, Red

### Typography
- Bold titles and headlines
- Medium weight for labels
- Regular for body text
- System font with custom weights

### Components
- **SectionCard** - White cards with rounded corners and soft shadows
- **StatusPill** - Rounded pill badges for status indicators
- **ProfileAvatar** - Circular avatar with initials
- **MenuRow** - Consistent menu item styling
- **FormField** - Styled form inputs
- **PrimaryButton** / **SecondaryButton** - Action buttons

### Shadows
- `cardShadow()` - Standard card elevation
- `softShadow()` - Subtle elevation
- `subtleShadow()` - Minimal elevation

## Project Structure

```
TimecardApp/
├── TimecardApp.xcodeproj/
└── TimecardApp/
    ├── TimecardAppApp.swift     # App entry point
    ├── ContentView.swift         # Root view
    ├── Models/
    │   └── Models.swift          # Data models
    ├── Views/
    │   ├── MainTabView.swift     # Tab bar
    │   ├── Profile/
    │   │   ├── ProfileView.swift
    │   │   ├── EditProfileView.swift
    │   │   ├── TimeOffRequestView.swift
    │   │   ├── HelpSupportView.swift
    │   │   ├── NotificationsView.swift
    │   │   └── SignatureView.swift
    │   ├── Timecard/
    │   │   └── TimecardView.swift
    │   ├── Entries/
    │   │   └── EntriesView.swift
    │   └── Summary/
    │       └── SummaryView.swift
    ├── Components/
    │   └── CardComponents.swift  # Reusable UI components
    ├── Styles/
    │   └── DesignSystem.swift    # Colors, typography, modifiers
    └── Assets.xcassets/
        ├── AccentColor.colorset/
        └── AppIcon.appiconset/
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `TimecardApp.xcodeproj` in Xcode
3. Build and run on simulator or device

## Screenshots Reference

The app is designed to match the provided profile-style design mockups featuring:
- Orange header with avatar overlapping
- Card-based sections with consistent styling
- Rounded status pills
- Soft shadows throughout
- Clean, modern iOS aesthetic

## License

MIT License
