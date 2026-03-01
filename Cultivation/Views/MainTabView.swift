import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("My Garden", systemImage: "leaf.fill") }

            VisualLayoutView()
                .tabItem { Label("Layout", systemImage: "square.grid.3x3.fill") }

            ScannerView()
                .tabItem { Label("Scan", systemImage: "viewfinder.circle.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .accentColor(.green)
    }
}
