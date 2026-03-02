import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID
    var taskTypeRaw: String
    var dueDate: Date
    var isCompleted: Bool
    var plantName: String
    var plantImageName: String
    var isOutdoor: Bool

    var taskType: TaskType {
        TaskType(rawValue: taskTypeRaw) ?? .water
    }

    init(
        taskType: TaskType,
        dueDate: Date,
        plantName: String,
        plantImageName: String,
        isOutdoor: Bool = false
    ) {
        self.id = UUID()
        self.taskTypeRaw = taskType.rawValue
        self.dueDate = dueDate
        self.plantName = plantName
        self.plantImageName = plantImageName
        self.isOutdoor = isOutdoor
        self.isCompleted = false
    }
}
