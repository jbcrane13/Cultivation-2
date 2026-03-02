import Foundation
import SwiftUI

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

enum PlantType: String, CaseIterable, Codable, Sendable {
    case vegetable
    case herb
    case flower
    case houseplant
    case fruit
    case succulent
    case tree
    case shrub

    var displayName: String {
        switch self {
        case .vegetable: return "Vegetable"
        case .herb: return "Herb"
        case .flower: return "Flower"
        case .houseplant: return "Houseplant"
        case .fruit: return "Fruit"
        case .succulent: return "Succulent"
        case .tree: return "Tree"
        case .shrub: return "Shrub"
        }
    }

    var emoji: String {
        switch self {
        case .vegetable: return "🥦"
        case .herb: return "🌿"
        case .flower: return "🌸"
        case .houseplant: return "🪴"
        case .fruit: return "🍓"
        case .succulent: return "🌵"
        case .tree: return "🌳"
        case .shrub: return "🌾"
        }
    }

    var description: String {
        switch self {
        case .vegetable: return "Tomatoes, peppers, squash…"
        case .herb: return "Basil, mint, rosemary…"
        case .flower: return "Marigolds, sunflowers…"
        case .houseplant: return "Pothos, ferns…"
        case .fruit: return "Strawberries, blueberries…"
        case .succulent: return "Aloe, sedum…"
        case .tree: return "Dwarf fruit trees…"
        case .shrub: return "Lavender, rosebush…"
        }
    }

    var slotColor: Color {
        switch self {
        case .vegetable: return Color.green.opacity(0.28)
        case .herb: return Color.mint.opacity(0.28)
        case .flower: return Color.pink.opacity(0.28)
        case .houseplant: return Color.teal.opacity(0.28)
        case .fruit: return Color.orange.opacity(0.28)
        case .succulent: return Color.yellow.opacity(0.28)
        case .tree: return Color.brown.opacity(0.32)
        case .shrub: return Color.indigo.opacity(0.28)
        }
    }
}
