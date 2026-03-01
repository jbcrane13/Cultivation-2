import Foundation

struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let species: String
    let imageName: String
    let waterNeeds: String
    let sunNeeds: String
    let isPetSafe: Bool
}
