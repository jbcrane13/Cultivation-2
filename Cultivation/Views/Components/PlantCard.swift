import SwiftUI

struct PlantCard: View {
    let plant: Plant

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            plantThumbnail
            plantInfo
        }
        .padding(14)
        .frame(width: 160)
        .glassCard()
    }

    private var plantThumbnail: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cultivationGreen.opacity(0.12))
                .frame(height: 110)
                .overlay(
                    Image(systemName: plant.imageName)
                        .font(.system(size: 44))
                        .foregroundStyle(Color.cultivationGreen)
                )
            if !plant.isPetSafe {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(6)
                    .background(Circle().fill(Color.black.opacity(0.7)))
                    .padding(6)
            }
        }
    }

    private var plantInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(plant.commonName)
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(.primary)
                .lineLimit(1)
            HStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)
                Text("Every \(plant.waterFrequencyDays)d")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
