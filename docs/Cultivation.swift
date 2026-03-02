import SwiftUI

// MARK: - Models
struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let species: String
    let imageName: String
    let waterNeeds: String
    let sunNeeds: String
    let isPetSafe: Bool
}

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

// MARK: - Main Application View
struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

// MARK: - Onboarding Flow
struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    
    @State private var selectedLevel: ExperienceLevel? = nil
    @State private var selectedGarden: GardenType? = nil
    
    var body: some View {
        ZStack {
            // Premium background
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color(UIColor.systemBackground)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Step Content
                if currentStep == 0 {
                    stepOneView
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if currentStep == 1 {
                    stepTwoView
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else {
                    stepThreeView
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
                
                Spacer()
                
                // Bottom Bar
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation(.spring()) { currentStep -= 1 }
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            if currentStep < 2 {
                                currentStep += 1
                            } else {
                                hasCompletedOnboarding = true
                            }
                        }
                    }) {
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
    }
    
    // MARK: Onboarding Steps
    var stepOneView: some View {
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
    
    var stepTwoView: some View {
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
    
    var stepThreeView: some View {
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
            
            // Mock Pet Feature Highlight
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
}

// MARK: - Reusable UI Components
struct SelectionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.green : Color(UIColor.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: isSelected ? .green.opacity(0.3) : .clear, radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("My Garden", systemImage: "leaf.fill")
                }
            
            VisualLayoutView()
                .tabItem {
                    Label("Layout", systemImage: "square.grid.3x3.fill")
                }
            
            ScannerView()
                .tabItem {
                    Label("Scan", systemImage: "viewfinder.circle.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.green)
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    let myPlants = [
        Plant(name: "Monstera", species: "Monstera deliciosa", imageName: "leaf", waterNeeds: "Every 1-2 weeks", sunNeeds: "Bright indirect", isPetSafe: false),
        Plant(name: "Cherry Tomato", species: "Solanum lycopersicum", imageName: "camera.macro", waterNeeds: "Daily in summer", sunNeeds: "Full Sun", isPetSafe: true)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Weather/Local Context Card
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

// MARK: - Visual Layout View (Drag & Drop Mock)
struct VisualLayoutView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Greenhouse Layout")
                    .font(.headline)
                    .padding()
                
                // Mock Grid Layout
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(0..<9) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(index == 4 ? Color.green.opacity(0.3) : Color(UIColor.tertiarySystemFill))
                            .frame(height: 100)
                            .overlay(
                                index == 4 ? Image(systemName: "leaf.fill").foregroundColor(.green) : nil
                            )
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {}) {
                    Label("Add Plant to Layout", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Layout")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// MARK: - Scanner View (Mock Camera)
struct ScannerView: View {
    var body: some View {
        ZStack {
            // Mock Camera Background
            Color.black.ignoresSafeArea()
            Image(systemName: "leaf")
                .font(.system(size: 200))
                .foregroundColor(.white.opacity(0.1))
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "bolt.slash.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(.black.opacity(0.5)))
                    }
                }
                .padding()
                
                Spacer()
                
                // Scanner Overlay
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 250, height: 250)
                    .overlay(
                        VStack {
                            Spacer()
                            Text("Align plant in frame")
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                    )
                
                Spacer()
                
                Button(action: {}) {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .background(Circle().fill(Color.green))
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = true
    @State private var petSafeMode = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile & Location")) {
                    Text("Location: Daphne, AL")
                    Text("Hardiness Zone: 8b")
                }
                
                Section(header: Text("Preferences"), footer: Text("Highlights plants that are toxic to dogs and cats.")) {
                    Toggle("Pet-Safe Mode", isOn: $petSafeMode)
                        .tint(.green)
                }
                
                Section {
                    Button("Reset Onboarding (Debug)") {
                        hasCompletedOnboarding = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}


