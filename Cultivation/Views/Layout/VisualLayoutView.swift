import SwiftUI
import SwiftData

struct VisualLayoutView: View {
    @Query private var slots: [GardenSlot]
    @Query private var plants: [Plant]
    @Environment(\.modelContext) private var modelContext

    @State private var showPlantPicker = false
    @State private var selectedSlotIndex: Int?

    private let columns = 4
    private let rows = 5
    private var totalSlots: Int { columns * rows }

    private func slotPlant(at index: Int) -> GardenSlot? {
        slots.first { $0.slotIndex == index }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    bedHeader
                    gridView
                        .padding(16)
                    addButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }
            }
            .navigationTitle("Garden Layout")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .sheet(isPresented: $showPlantPicker) {
            PlantPickerSheet(plants: plants) { plant in
                if let index = selectedSlotIndex {
                    placeInSlot(plant: plant, at: index)
                }
                showPlantPicker = false
                selectedSlotIndex = nil
            }
        }
    }

    // MARK: - Header

    private var bedHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "square.grid.3x3.fill")
                .foregroundStyle(Color.cultivationGreen)
            VStack(alignment: .leading, spacing: 2) {
                Text("Raised Bed · Zone 8b")
                    .font(.subheadline.weight(.semibold))
                    .fontDesign(.rounded)
                Text("\(slots.count) of \(totalSlots) slots occupied")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .glassCard(cornerRadius: 0)
    }

    // MARK: - Grid

    private var gridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns),
            spacing: 8
        ) {
            ForEach(0..<totalSlots, id: \.self) { index in
                GardenSlotCell(
                    slot: slotPlant(at: index),
                    index: index
                ) {
                    if slotPlant(at: index) != nil {
                        removeFromSlot(at: index)
                    } else {
                        selectedSlotIndex = index
                        showPlantPicker = true
                    }
                }
            }
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            selectedSlotIndex = firstEmptySlot()
            showPlantPicker = true
        } label: {
            Label("Add Plant to Bed", systemImage: "plus")
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.cultivationGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.cultivationGreen.opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }

    // MARK: - Actions

    private func placeInSlot(plant: Plant, at index: Int) {
        let slot = GardenSlot(
            slotIndex: index,
            plantName: plant.commonName,
            plantImageName: plant.imageName,
            isPetSafe: plant.isPetSafe
        )
        modelContext.insert(slot)
    }

    private func removeFromSlot(at index: Int) {
        if let slot = slotPlant(at: index) {
            modelContext.delete(slot)
        }
    }

    private func firstEmptySlot() -> Int? {
        let occupied = Set(slots.map(\.slotIndex))
        return (0..<totalSlots).first { !occupied.contains($0) }
    }
}

// MARK: - Slot Cell

struct GardenSlotCell: View {
    let slot: GardenSlot?
    let index: Int
    let onTap: () -> Void

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(slot != nil ? Color.cultivationGreen.opacity(0.18) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                slot != nil ? Color.cultivationGreen.opacity(0.35) : Color.white.opacity(0.08),
                                lineWidth: 1
                            )
                    )
                if let slot {
                    VStack(spacing: 4) {
                        Image(systemName: slot.plantImageName)
                            .font(.system(size: 22))
                            .foregroundStyle(Color.cultivationGreen)
                        Text(slot.plantName)
                            .font(.system(size: 9, weight: .semibold))
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .light))
                        .foregroundStyle(Color.white.opacity(0.2))
                }
            }
            .frame(height: 72)
        }
    }
}

// MARK: - Plant Picker Sheet

struct PlantPickerSheet: View {
    let plants: [Plant]
    let onSelect: (Plant) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                if plants.isEmpty {
                    ContentUnavailableView(
                        "No Plants Yet",
                        systemImage: "leaf",
                        description: Text("Add plants by scanning them in the Scanner tab.")
                    )
                } else {
                    List(plants) { plant in
                        Button {
                            onSelect(plant)
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: plant.imageName)
                                    .font(.title2)
                                    .foregroundStyle(Color.cultivationGreen)
                                    .frame(width: 36)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(plant.commonName)
                                        .font(.headline)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.primary)
                                    Text(plant.species)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if !plant.isPetSafe {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.white.opacity(0.06))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Choose Plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .presentationDetents([.medium, .large])
    }
}
