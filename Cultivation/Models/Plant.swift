import Foundation
import SwiftData

@Model
final class Plant {
    var id: UUID
    var commonName: String
    var species: String
    var imageName: String
    var waterFrequencyDays: Int
    var sunRequirement: String
    var isPetSafe: Bool
    var datePlanted: Date
    var notes: String

    init(
        commonName: String,
        species: String,
        imageName: String,
        waterFrequencyDays: Int,
        sunRequirement: String,
        isPetSafe: Bool,
        datePlanted: Date = .now,
        notes: String = ""
    ) {
        self.id = UUID()
        self.commonName = commonName
        self.species = species
        self.imageName = imageName
        self.waterFrequencyDays = waterFrequencyDays
        self.sunRequirement = sunRequirement
        self.isPetSafe = isPetSafe
        self.datePlanted = datePlanted
        self.notes = notes
    }
}
