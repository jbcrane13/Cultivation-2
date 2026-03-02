import SwiftUI

struct ScannerView: View {
    @State private var scanLineY: CGFloat = -100
    @State private var isScanning = false
    @State private var showResult = false
    @State private var currentResult: ScanResult?
    @State private var torchOn = false

    private let mockResults: [ScanResult] = [
        ScanResult(
            commonName: "Monstera",
            species: "Monstera deliciosa",
            isPetSafe: false,
            confidence: 97,
            care: "Water every 1–2 weeks. Bright indirect light. Wipe leaves monthly.",
            imageName: "leaf.fill"
        ),
        ScanResult(
            commonName: "Pothos",
            species: "Epipremnum aureum",
            isPetSafe: false,
            confidence: 94,
            care: "Tolerates low light. Water when top inch of soil is dry.",
            imageName: "ant.circle.fill"
        ),
        ScanResult(
            commonName: "Spider Plant",
            species: "Chlorophytum comosum",
            isPetSafe: true,
            confidence: 99,
            care: "Water weekly in summer, every 2–3 weeks in winter. Indirect light.",
            imageName: "circle.grid.2x2.fill"
        )
    ]

    var body: some View {
        ZStack {
            cameraBackground
            VStack {
                topBar
                Spacer()
                viewfinder
                instructionLabel
                Spacer()
                shutterButton
                    .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showResult) {
            if let result = currentResult {
                ScanResultView(result: result)
            }
        }
    }

    // MARK: - Camera Background

    private var cameraBackground: some View {
        ZStack {
            Color.black
            Image(systemName: "leaf")
                .font(.system(size: 220))
                .foregroundStyle(Color.white.opacity(0.03))
        }
        .ignoresSafeArea()
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()
            Text("Plant Scanner")
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            Spacer()
            Button {
                torchOn.toggle()
            } label: {
                Image(systemName: torchOn ? "bolt.fill" : "bolt.slash.fill")
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Circle().fill(Color.white.opacity(0.15)))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
    }

    // MARK: - Viewfinder

    private var viewfinder: some View {
        ZStack {
            if isScanning {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, Color.cultivationGreen.opacity(0.8), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .offset(y: scanLineY)
                    .animation(.linear(duration: 1.4).repeatForever(autoreverses: true), value: scanLineY)
            }
            ViewfinderBrackets()
                .stroke(Color.cultivationGreen, lineWidth: 2.5)
        }
        .frame(width: 264, height: 264)
        .onAppear {
            scanLineY = -100
        }
    }

    // MARK: - Instruction

    private var instructionLabel: some View {
        Text(isScanning ? "Analysing…" : "Align plant in frame")
            .font(.subheadline)
            .fontDesign(.rounded)
            .foregroundStyle(.white.opacity(0.7))
            .padding(.top, 20)
            .animation(.easeInOut, value: isScanning)
    }

    // MARK: - Shutter

    private var shutterButton: some View {
        Button {
            performScan()
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(Color.white.opacity(0.6), lineWidth: 3)
                    .frame(width: 76, height: 76)
                Circle()
                    .fill(isScanning ? Color.orange : Color.cultivationGreen)
                    .frame(width: 58, height: 58)
                    .animation(.easeInOut(duration: 0.2), value: isScanning)
                if isScanning {
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .disabled(isScanning)
    }

    // MARK: - Scan Logic

    private func performScan() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isScanning = true
        scanLineY = -100
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            currentResult = mockResults.randomElement()
            isScanning = false
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            showResult = true
        }
    }
}

// MARK: - Viewfinder Shape

struct ViewfinderBrackets: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let len: CGFloat = 28
        let radius: CGFloat = 8

        func addCorner(origin: CGPoint, dx: CGFloat, dy: CGFloat) {
            path.move(to: CGPoint(x: origin.x + dx * len, y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + dx * radius, y: origin.y))
            path.addQuadCurve(
                to: CGPoint(x: origin.x, y: origin.y + dy * radius),
                control: CGPoint(x: origin.x, y: origin.y)
            )
            path.addLine(to: CGPoint(x: origin.x, y: origin.y + dy * len))
        }

        addCorner(origin: CGPoint(x: rect.minX, y: rect.minY), dx: 1, dy: 1)
        addCorner(origin: CGPoint(x: rect.maxX, y: rect.minY), dx: -1, dy: 1)
        addCorner(origin: CGPoint(x: rect.minX, y: rect.maxY), dx: 1, dy: -1)
        addCorner(origin: CGPoint(x: rect.maxX, y: rect.maxY), dx: -1, dy: -1)
        return path
    }
}

// MARK: - Scan Result Model

struct ScanResult {
    let commonName: String
    let species: String
    let isPetSafe: Bool
    let confidence: Int
    let care: String
    let imageName: String
}

// MARK: - Scan Result View

struct ScanResultView: View {
    let result: ScanResult
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        plantHero
                        if !result.isPetSafe {
                            petSafeAlert
                        }
                        confidenceBadge
                        careCard
                        addButton
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Scan Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(.black)
    }

    private var plantHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.cultivationGreen.opacity(0.15))
                    .frame(width: 100, height: 100)
                Image(systemName: result.imageName)
                    .font(.system(size: 50))
                    .foregroundStyle(Color.cultivationGreen)
            }
            Text(result.commonName)
                .font(.title.bold())
                .fontDesign(.rounded)
            Text(result.species)
                .font(.subheadline)
                .italic()
                .foregroundStyle(.secondary)
        }
    }

    private var petSafeAlert: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.red)
            VStack(alignment: .leading, spacing: 4) {
                Text("Not Pet-Safe")
                    .font(.headline)
                    .fontDesign(.rounded)
                    .foregroundStyle(.red)
                Text("Toxic to dogs and cats if ingested. Keep away from pets.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.red.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }

    private var confidenceBadge: some View {
        HStack {
            Label("Match Confidence", systemImage: "brain.head.profile")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(result.confidence)%")
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(Color.cultivationGreen)
        }
        .padding()
        .glassCard()
    }

    private var careCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Care Guide", systemImage: "leaf.circle.fill")
                .font(.subheadline.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(Color.cultivationGreen)
            Text(result.care)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .glassCard()
    }

    private var addButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            dismiss()
        } label: {
            Label("Add to My Garden", systemImage: "plus")
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.cultivationGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.cultivationGreen.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 4)
    }
}
