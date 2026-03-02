import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = true
    @AppStorage("petSafeModeEnabled") private var petSafeModeEnabled: Bool = false
    @AppStorage("experienceLevel") private var experienceLevelRaw: String = ExperienceLevel.beginner.rawValue
    @Environment(\.modelContext) private var modelContext
    @Query private var plants: [Plant]
    @Query private var tasks: [TaskItem]

    private let weather = WeatherService.currentWeather()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                List {
                    profileSection
                    preferencesSection
                    gardenStatsSection
                    debugSection
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Profile

    private var profileSection: some View {
        Section {
            labelRow(
                icon: "mappin.circle.fill",
                iconColor: .cultivationGreen,
                title: "Location",
                value: weather.locationName
            )
            labelRow(
                icon: "thermometer.medium",
                iconColor: .orange,
                title: "Hardiness Zone",
                value: weather.zone
            )
            labelRow(
                icon: "graduationcap.fill",
                iconColor: .blue,
                title: "Experience",
                value: experienceLevelRaw
            )
        } header: {
            Text("Profile")
                .foregroundStyle(Color.cultivationGreen)
        }
        .listRowBackground(Color.white.opacity(0.07))
    }

    // MARK: - Preferences

    private var preferencesSection: some View {
        Section {
            Toggle(isOn: $petSafeModeEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(.orange)
                        .frame(width: 24)
                    Text("Pet-Safe Mode")
                        .font(.body)
                }
            }
            .tint(.cultivationGreen)
        } header: {
            Text("Preferences")
                .foregroundStyle(Color.cultivationGreen)
        } footer: {
            Text("Filters and flags plants toxic to dogs and cats.")
                .foregroundStyle(.secondary)
        }
        .listRowBackground(Color.white.opacity(0.07))
    }

    // MARK: - Stats

    private var gardenStatsSection: some View {
        Section {
            labelRow(
                icon: "leaf.fill",
                iconColor: .cultivationGreen,
                title: "Total Plants",
                value: "\(plants.count)"
            )
            labelRow(
                icon: "checklist",
                iconColor: .blue,
                title: "Pending Tasks",
                value: "\(tasks.filter { !$0.isCompleted }.count)"
            )
            labelRow(
                icon: "exclamationmark.triangle.fill",
                iconColor: .red,
                title: "Non-Pet-Safe Plants",
                value: "\(plants.filter { !$0.isPetSafe }.count)"
            )
        } header: {
            Text("Garden Stats")
                .foregroundStyle(Color.cultivationGreen)
        }
        .listRowBackground(Color.white.opacity(0.07))
    }

    // MARK: - Debug

    private var debugSection: some View {
        Section {
            Button("Reset Onboarding") {
                hasCompletedOnboarding = false
            }
            .foregroundStyle(.red)
            Button("Clear All Data") {
                plants.forEach { modelContext.delete($0) }
                tasks.forEach { modelContext.delete($0) }
            }
            .foregroundStyle(.red)
        } header: {
            Text("Developer")
                .foregroundStyle(Color.cultivationGreen)
        }
        .listRowBackground(Color.white.opacity(0.07))
    }

    // MARK: - Helpers

    private func labelRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
