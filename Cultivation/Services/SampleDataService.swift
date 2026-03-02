import Foundation
import SwiftData

struct SampleDataService {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Plant>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }
        seedPlants(context: context)
        seedTasks(context: context)
    }

    private static func seedPlants(context: ModelContext) {
        let plants: [Plant] = [
            Plant(
                commonName: "Monstera",
                species: "Monstera deliciosa",
                imageName: "leaf.fill",
                waterFrequencyDays: 10,
                sunRequirement: "Bright indirect",
                isPetSafe: false
            ),
            Plant(
                commonName: "Cherry Tomato",
                species: "Solanum lycopersicum",
                imageName: "camera.macro",
                waterFrequencyDays: 1,
                sunRequirement: "Full sun",
                isPetSafe: true,
                datePlanted: Calendar.current.date(byAdding: .day, value: -30, to: .now) ?? .now
            ),
            Plant(
                commonName: "Basil",
                species: "Ocimum basilicum",
                imageName: "leaf.circle.fill",
                waterFrequencyDays: 2,
                sunRequirement: "Full sun",
                isPetSafe: true,
                datePlanted: Calendar.current.date(byAdding: .day, value: -14, to: .now) ?? .now
            ),
            Plant(
                commonName: "Pothos",
                species: "Epipremnum aureum",
                imageName: "ant.circle.fill",
                waterFrequencyDays: 7,
                sunRequirement: "Low to bright indirect",
                isPetSafe: false
            ),
            Plant(
                commonName: "Spider Plant",
                species: "Chlorophytum comosum",
                imageName: "circle.grid.2x2.fill",
                waterFrequencyDays: 5,
                sunRequirement: "Indirect light",
                isPetSafe: true
            )
        ]
        plants.forEach { context.insert($0) }
    }

    private static func seedTasks(context: ModelContext) {
        let today = Calendar.current.startOfDay(for: .now)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        let inThreeDays = Calendar.current.date(byAdding: .day, value: 3, to: today) ?? today

        let tasks: [TaskItem] = [
            TaskItem(
                taskType: .water,
                dueDate: today,
                plantName: "Monstera",
                plantImageName: "leaf.fill",
                isOutdoor: false
            ),
            TaskItem(
                taskType: .water,
                dueDate: today,
                plantName: "Cherry Tomato",
                plantImageName: "camera.macro",
                isOutdoor: true
            ),
            TaskItem(
                taskType: .fertilize,
                dueDate: yesterday,
                plantName: "Basil",
                plantImageName: "leaf.circle.fill",
                isOutdoor: true
            ),
            TaskItem(
                taskType: .prune,
                dueDate: tomorrow,
                plantName: "Pothos",
                plantImageName: "ant.circle.fill",
                isOutdoor: false
            ),
            TaskItem(
                taskType: .harvest,
                dueDate: inThreeDays,
                plantName: "Cherry Tomato",
                plantImageName: "camera.macro",
                isOutdoor: true
            )
        ]
        tasks.forEach { context.insert($0) }
    }
}
