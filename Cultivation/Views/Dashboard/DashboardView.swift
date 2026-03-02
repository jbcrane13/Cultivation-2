import SwiftUI

struct DashboardView: View {
    let myPlants = [
        Plant(
            name: "Monstera",
            species: "Monstera deliciosa",
            imageName: "leaf",
            waterNeeds: "Every 1-2 weeks",
            sunNeeds: "Bright indirect",
            isPetSafe: false
        ),
        Plant(
            name: "Cherry Tomato",
            species: "Solanum lycopersicum",
            imageName: "camera.macro",
            waterNeeds: "Daily in summer",
            sunNeeds: "Full Sun",
            isPetSafe: true
        )
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Weather context card
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Daphne, AL • Zone 8b")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Heavy rain expected tomorrow.")
                                .font(.headline)
                            Text("Outdoor watering schedules paused.")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Image(systemName: "cloud.rain.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal)

                    Text("Needs Attention")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(myPlants) { plant in
                                PlantCard(plant: plant)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("My Garden")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
