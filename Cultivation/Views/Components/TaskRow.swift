import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let weatherSuppressed: Bool
    var onToggle: () -> Void

    private var iconColor: Color {
        switch task.taskType {
        case .water: return .blue
        case .fertilize: return .cultivationGreen
        case .prune: return .orange
        case .harvest: return .yellow
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            taskIcon
            taskInfo
            Spacer()
            if weatherSuppressed {
                weatherBadge
            } else {
                toggleButton
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 16)
        .opacity(task.isCompleted ? 0.5 : 1)
    }

    private var taskIcon: some View {
        Circle()
            .fill(iconColor.opacity(0.18))
            .frame(width: 46, height: 46)
            .overlay(
                Image(systemName: task.taskType.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconColor)
            )
    }

    private var taskInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.taskType.rawValue + " — " + task.plantName)
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(task.isCompleted ? .secondary : .primary)
                .strikethrough(task.isCompleted, color: .secondary)
            Text(task.isCompleted ? "Completed" : dueDateLabel)
                .font(.caption)
                .foregroundStyle(dueDateColor)
        }
    }

    private var toggleButton: some View {
        Button {
            onToggle()
        } label: {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(task.isCompleted ? Color.cultivationGreen : Color.white.opacity(0.3))
        }
    }

    private var weatherBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "cloud.rain.fill")
                .font(.caption)
            Text("Paused")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.blue)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.blue.opacity(0.15))
        .clipShape(Capsule())
    }

    private var dueDateLabel: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let due = calendar.startOfDay(for: task.dueDate)
        let days = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        if days == 0 { return "Due today" }
        if days < 0 { return "Overdue \(-days)d" }
        return "In \(days) day\(days == 1 ? "" : "s")"
    }

    private var dueDateColor: Color {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let due = calendar.startOfDay(for: task.dueDate)
        let days = calendar.dateComponents([.day], from: today, to: due).day ?? 0
        if days < 0 { return .red }
        if days == 0 { return .orange }
        return .secondary
    }
}
