import Foundation

enum ExperienceLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case expert = "Master Gardener"
}

enum GardenType: String, CaseIterable {
    case indoor = "Indoor Pots"
    case balcony = "Balcony"
    case raisedBed = "Raised Beds"
    case greenhouse = "Greenhouse"
}

enum TaskType: String, CaseIterable, Codable {
    case water = "Water"
    case fertilize = "Fertilize"
    case prune = "Prune"
    case harvest = "Harvest"

    var icon: String {
        switch self {
        case .water: return "drop.fill"
        case .fertilize: return "leaf.fill"
        case .prune: return "scissors"
        case .harvest: return "basket.fill"
        }
    }
}
