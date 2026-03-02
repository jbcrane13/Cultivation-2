import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var tasks: [TaskItem]
    @Query private var plants: [Plant]
    @AppStorage("petSafeModeEnabled") private var petSafeModeEnabled = false

    private let weather = WeatherService.currentWeather()

    private var pendingTasks: [TaskItem] {
        tasks
            .filter { !$0.isCompleted }
            .sorted { $0.dueDate < $1.dueDate }
    }

    private var visiblePlants: [Plant] {
        petSafeModeEnabled ? plants.filter(\.isPetSafe) : plants
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        weatherCard
                        tasksSection
                        plantsSection
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("My Garden")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Weather Card

    private var weatherCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(Color.cultivationGreen)
                    Text(weather.locationName + " • " + weather.zone)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                Text(weather.forecastSummary)
                    .font(.subheadline.weight(.semibold))
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                if weather.suppressOutdoorWatering {
                    Label("Outdoor watering paused \(weather.suppressDays) days", systemImage: "drop.slash")
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(.top, 2)
                }
            }
            Spacer()
            Image(systemName: weather.condition.icon)
                .font(.system(size: 44))
                .foregroundStyle(.blue)
                .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .padding(18)
        .glassCard()
        .padding(.horizontal, 16)
    }

    // MARK: - Tasks Section

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Today's Tasks", count: pendingTasks.count)
                .padding(.horizontal, 16)
            if pendingTasks.isEmpty {
                emptyTasksView
                    .padding(.horizontal, 16)
            } else {
                VStack(spacing: 10) {
                    ForEach(pendingTasks) { task in
                        TaskRow(
                            task: task,
                            weatherSuppressed: task.isOutdoor
                                && weather.suppressOutdoorWatering
                                && task.taskType == .water
                        ) {
                            task.isCompleted = true
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var emptyTasksView: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .font(.title2)
                .foregroundStyle(Color.cultivationGreen)
            Text("All caught up! No tasks due.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .glassCard()
    }

    // MARK: - Plants Section

    private var plantsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("My Plants", count: visiblePlants.count)
                .padding(.horizontal, 16)
            if visiblePlants.isEmpty {
                emptyPlantsView
                    .padding(.horizontal, 16)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(visiblePlants) { plant in
                            PlantCard(plant: plant)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private var emptyPlantsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.macro")
                .font(.system(size: 48))
                .foregroundStyle(Color.cultivationGreen.opacity(0.6))
            Text("Scan your first plant to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .glassCard()
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, count: Int) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title3.weight(.bold))
                .fontDesign(.rounded)
            Text("\(count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.cultivationGreen)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.cultivationGreen.opacity(0.15))
                .clipShape(Capsule())
        }
    }
}
