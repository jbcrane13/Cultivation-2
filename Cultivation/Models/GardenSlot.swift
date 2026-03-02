import Foundation
import SwiftData

@Model
final class GardenSlot {
    var slotIndex: Int
    var plantName: String
    var plantImageName: String
    var isPetSafe: Bool

    init(
        slotIndex: Int,
        plantName: String,
        plantImageName: String,
        isPetSafe: Bool = true
    ) {
        self.slotIndex = slotIndex
        self.plantName = plantName
        self.plantImageName = plantImageName
        self.isPetSafe = isPetSafe
    }
}
