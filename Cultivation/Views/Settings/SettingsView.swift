import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = true
    @State private var petSafeMode = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile & Location")) {
                    Text("Location: Daphne, AL")
                    Text("Hardiness Zone: 8b")
                }

                Section(
                    header: Text("Preferences"),
                    footer: Text("Highlights plants that are toxic to dogs and cats.")
                ) {
                    Toggle("Pet-Safe Mode", isOn: $petSafeMode)
                        .tint(.green)
                }

                Section {
                    Button("Reset Onboarding (Debug)") {
                        hasCompletedOnboarding = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
