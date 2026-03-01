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
