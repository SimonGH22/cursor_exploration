import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TimecardView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Timecard")
                }
                .tag(0)
            
            EntriesView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.fill")
                    Text("Entries")
                }
                .tag(1)
            
            SummaryView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .tint(.primaryOrange)
    }
}

#Preview {
    MainTabView()
}
