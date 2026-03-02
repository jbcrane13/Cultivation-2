import SwiftUI
import SwiftData

@main
struct CultivationApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Plant.self,
                TaskItem.self
            )
        } catch {
            fatalError("SwiftData container failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .modelContainer(container)
        }
    }
}
