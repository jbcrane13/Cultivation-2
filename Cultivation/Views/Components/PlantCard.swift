import SwiftUI

struct PlantCard: View {
    let plant: Plant

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 160, height: 120)
                    .overlay(
                        Image(systemName: plant.imageName)
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                    )

                if !plant.isPetSafe {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Circle().fill(.white))
                        .padding(8)
                }
            }

            Text(plant.name)
                .font(.headline)
            Text(plant.waterNeeds)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
