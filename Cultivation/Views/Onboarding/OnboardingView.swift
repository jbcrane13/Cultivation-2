import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    @State private var selectedLevel: ExperienceLevel?
    @State private var selectedGarden: GardenType?
    @State private var petSafeMode = false

    private let totalSteps = 4

    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: 0) {
                progressDots
                    .padding(.top, 20)
                stepContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                navigationBar
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RadialGradient(
                colors: [Color.cultivationGreen.opacity(0.25), Color.clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }

    // MARK: - Progress

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index == currentStep ? Color.cultivationGreen : Color.white.opacity(0.25))
                    .frame(width: index == currentStep ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.35), value: currentStep)
            }
        }
    }

    // MARK: - Step content

    @ViewBuilder
    private var stepContent: some View {
        Group {
            switch currentStep {
            case 0: experienceLevelStep
            case 1: gardenTypeStep
            case 2: petSafeStep
            default: getStartedStep
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .id(currentStep)
    }

    // MARK: - Steps

    private var experienceLevelStep: some View {
        VStack(spacing: 24) {
            stepIcon("leaf.arrow.triangle.circlepath")
            stepHeadline("Welcome to Cultivation")
            stepSubtitle("Let's personalise your care guides. What is your gardening experience level?")
            VStack(spacing: 12) {
                ForEach(ExperienceLevel.allCases, id: \.self) { level in
                    SelectionCard(
                        title: level.rawValue,
                        isSelected: selectedLevel == level
                    ) {
                        selectedLevel = level
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 28)
    }

    private var gardenTypeStep: some View {
        VStack(spacing: 24) {
            stepIcon("house.lodge.fill")
            stepHeadline("Where do you grow?")
            stepSubtitle("We'll optimise sunlight and watering advice for your environment.")
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(GardenType.allCases, id: \.self) { type in
                    SelectionCard(
                        title: type.rawValue,
                        isSelected: selectedGarden == type
                    ) {
                        selectedGarden = type
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 28)
    }

    private var petSafeStep: some View {
        VStack(spacing: 24) {
            stepIcon("pawprint.fill")
                .foregroundStyle(Color.orange)
            stepHeadline("Pet-Safe Mode")
            stepSubtitle("Enable to flag and filter plants toxic to dogs and cats — keeping Julep and Koda safe.")
            Toggle(isOn: $petSafeMode) {
                HStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                        .foregroundStyle(.orange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pet-Safe Filtering")
                            .font(.headline)
                            .fontDesign(.rounded)
                        Text("Flags toxic plants with a warning badge")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .tint(.cultivationGreen)
            .padding()
            .glassCard()
            .padding(.top, 8)
        }
        .padding(.horizontal, 28)
    }

    private var getStartedStep: some View {
        VStack(spacing: 24) {
            stepIcon("camera.viewfinder")
            stepHeadline("Identify & Learn")
            stepSubtitle("Point your camera at any plant to identify it, detect disease, and map your garden in AR.")
            VStack(spacing: 12) {
                featureRow(icon: "brain.head.profile", label: "AI plant identification — works offline")
                featureRow(icon: "arkit", label: "AR garden layout mapping")
                featureRow(icon: "cloud.rain.fill", label: "WeatherKit adaptive care engine")
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 28)
    }

    // MARK: - Helpers

    private func stepIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 64))
            .foregroundStyle(Color.cultivationGreen)
            .padding(.bottom, 4)
    }

    private func stepHeadline(_ text: String) -> some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .multilineTextAlignment(.center)
    }

    private func stepSubtitle(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }

    private func featureRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.cultivationGreen)
                .frame(width: 32)
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding()
        .glassCard()
    }

    // MARK: - Navigation

    private var navigationBar: some View {
        HStack {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation(.spring(response: 0.35)) { currentStep -= 1 }
                }
                .foregroundStyle(.secondary)
                .font(.body.weight(.medium))
            }
            Spacer()
            nextButton
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 24)
    }

    private var nextButton: some View {
        Button {
            withAnimation(.spring(response: 0.35)) {
                if currentStep < totalSteps - 1 {
                    currentStep += 1
                } else {
                    UserDefaults.standard.set(petSafeMode, forKey: "petSafeModeEnabled")
                    if let level = selectedLevel {
                        UserDefaults.standard.set(level.rawValue, forKey: "experienceLevel")
                    }
                    hasCompletedOnboarding = true
                }
            }
        } label: {
            Text(currentStep == totalSteps - 1 ? "Get Started" : "Next")
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.cultivationGreen)
                .clipShape(Capsule())
                .shadow(color: Color.cultivationGreen.opacity(0.45), radius: 12, x: 0, y: 6)
        }
    }
}
