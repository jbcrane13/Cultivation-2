import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    @State private var selectedLevel: ExperienceLevel?
    @State private var selectedGarden: GardenType?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.3), Color(UIColor.systemBackground)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                Group {
                    switch currentStep {
                    case 0: welcomeStep
                    case 1: gardenTypeStep
                    default: identifyStep
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)
                ))

                Spacer()

                navigationBar
            }
        }
    }

    // MARK: - Steps

    private var welcomeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf.arrow.triangle.circlepath")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding(.bottom, 20)

            Text("Welcome to Cultivation")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Let's personalize your care guides. What is your gardening experience level?")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(ExperienceLevel.allCases, id: \.self) { level in
                    SelectionCard(title: level.rawValue, isSelected: selectedLevel == level) {
                        selectedLevel = level
                    }
                }
            }
            .padding(.top, 20)
        }
    }

    private var gardenTypeStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.lodge")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding(.bottom, 20)

            Text("Where do you grow?")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("We'll optimize sunlight and watering advice based on your environment.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(GardenType.allCases, id: \.self) { type in
                    SelectionCard(title: type.rawValue, isSelected: selectedGarden == type) {
                        selectedGarden = type
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }

    private var identifyStep: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding(.bottom, 20)

            Text("Identify & Learn")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Use your camera to instantly identify plants, detect diseases, and map out your garden layout.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            HStack {
                Image(systemName: "pawprint.fill")
                    .foregroundColor(.orange)
                Text("Pet-Safe Mode enabled for dogs.")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .padding(.top, 20)
        }
    }

    // MARK: - Navigation

    private var navigationBar: some View {
        HStack {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation(.spring()) {
                        currentStep -= 1
                    }
                }
                .foregroundColor(.secondary)
            }

            Spacer()

            Button {
                withAnimation(.spring()) {
                    if currentStep < 2 {
                        currentStep += 1
                    } else {
                        hasCompletedOnboarding = true
                    }
                }
            } label: {
                Text(currentStep == 2 ? "Get Started" : "Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .shadow(color: .green.opacity(0.4), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
}
