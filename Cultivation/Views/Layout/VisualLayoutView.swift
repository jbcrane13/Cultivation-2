// swiftlint:disable file_length
import SwiftUI

// MARK: - Layout Data Models
// Ported from GrowWise GardenLayoutView — stored as JSON in AppStorage.

struct GardenLayoutData: Codable, Sendable, Equatable {
    var beds: [GardenBedData] = []

    static func from(jsonString: String) -> GardenLayoutData {
        guard
            !jsonString.isEmpty,
            let data = jsonString.data(using: .utf8),
            let layout = try? JSONDecoder().decode(GardenLayoutData.self, from: data)
        else { return GardenLayoutData() }
        return layout
    }

    func jsonString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

struct GardenBedData: Codable, Identifiable, Sendable, Equatable {
    var id = UUID()
    var name: String
    var widthFeet: Int
    var heightFeet: Int
    var slots: [[PlantSlot]]

    init(name: String = "Bed", widthFeet: Int = 4, heightFeet: Int = 8) {
        self.name = name
        self.widthFeet = widthFeet
        self.heightFeet = heightFeet
        slots = Array(repeating: Array(repeating: PlantSlot(), count: widthFeet), count: heightFeet)
    }

    var squareFeet: Int { widthFeet * heightFeet }
    var dimensionLabel: String { "\(widthFeet)×\(heightFeet) ft (\(squareFeet) sq ft)" }

    mutating func resize(width: Int, height: Int) {
        let clampedWidth = max(1, min(width, 12))
        let clampedHeight = max(1, min(height, 20))
        var newSlots = Array(
            repeating: Array(repeating: PlantSlot(), count: clampedWidth),
            count: clampedHeight
        )
        for row in 0 ..< min(clampedHeight, slots.count) {
            for col in 0 ..< min(clampedWidth, slots[row].count) {
                newSlots[row][col] = slots[row][col]
            }
        }
        slots = newSlots
        widthFeet = clampedWidth
        heightFeet = clampedHeight
    }

    mutating func setSlot(row: Int, col: Int, plant: PlantSlot) {
        guard row < slots.count, col < slots[row].count else { return }
        slots[row][col] = plant
    }

    func slotAt(row: Int, col: Int) -> PlantSlot {
        guard row < slots.count, col < slots[row].count else { return PlantSlot() }
        return slots[row][col]
    }
}

struct PlantSlot: Codable, Sendable, Equatable {
    var plantName: String?
    var plantTypeRaw: String?

    var isEmpty: Bool { plantName == nil }

    var plantType: PlantType? {
        plantTypeRaw.flatMap { PlantType(rawValue: $0) }
    }

    var slotColor: Color {
        plantType?.slotColor ?? Color.clear
    }
}

// MARK: - Main View

struct VisualLayoutView: View {
    @AppStorage("gardenLayoutJSON") private var layoutJSON: String = ""
    @State private var layoutData = GardenLayoutData()
    @State private var showingAddBed = false
    @State private var bedBeingEdited: GardenBedData?
    @State private var selectedSlot: SelectedSlot?

    struct SelectedSlot: Identifiable {
        let id = UUID()
        let bedID: UUID
        let row: Int
        let col: Int
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if layoutData.beds.isEmpty {
                            emptyState
                        } else {
                            ForEach(layoutData.beds) { bed in
                                BedCard(
                                    bed: bed,
                                    onSlotTap: { row, col in
                                        selectedSlot = SelectedSlot(bedID: bed.id, row: row, col: col)
                                    },
                                    onEdit: { bedBeingEdited = bed },
                                    onDelete: {
                                        withAnimation(.easeInOut) {
                                            layoutData.beds.removeAll { $0.id == bed.id }
                                        }
                                        saveLayout()
                                    }
                                )
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Garden Layout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar { toolbarItems }
        }
        .onAppear { layoutData = GardenLayoutData.from(jsonString: layoutJSON) }
        .sheet(isPresented: $showingAddBed, onDismiss: saveLayout) {
            AddBedSheet(bedNumber: layoutData.beds.count + 1) { name, width, height in
                let newBed = GardenBedData(name: name, widthFeet: width, heightFeet: height)
                withAnimation(.easeInOut) { layoutData.beds.append(newBed) }
            }
        }
        .sheet(item: $bedBeingEdited, onDismiss: saveLayout) { bed in
            EditBedSheet(
                initial: bed,
                onSave: { updated in
                    if let idx = layoutData.beds.firstIndex(where: { $0.id == updated.id }) {
                        layoutData.beds[idx] = updated
                    }
                    bedBeingEdited = nil
                    saveLayout()
                },
                onCancel: { bedBeingEdited = nil }
            )
        }
        .sheet(item: $selectedSlot, onDismiss: saveLayout) { slot in
            if let idx = layoutData.beds.firstIndex(where: { $0.id == slot.bedID }) {
                PlantSlotPickerSheet(
                    current: layoutData.beds[idx].slotAt(row: slot.row, col: slot.col),
                    onPick: { newSlot in
                        layoutData.beds[idx].setSlot(row: slot.row, col: slot.col, plant: newSlot)
                        selectedSlot = nil
                        saveLayout()
                    },
                    onClear: {
                        layoutData.beds[idx].setSlot(row: slot.row, col: slot.col, plant: PlantSlot())
                        selectedSlot = nil
                        saveLayout()
                    }
                )
            }
        }
    }

    @ToolbarContentBuilder private var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                showingAddBed = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "plus")
                    Text("Bed")
                }
                .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.cultivationGreen)
            .controlSize(.small)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.dashed")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("No Beds Yet")
                .font(.title2.weight(.semibold))
                .fontDesign(.rounded)
            Text("Tap \"+ Bed\" to design your first raised bed or planting area.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
            Button {
                showingAddBed = true
            } label: {
                Label("Add First Bed", systemImage: "plus")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.cultivationGreen)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }

    private func saveLayout() {
        layoutJSON = layoutData.jsonString() ?? ""
    }
}

// MARK: - Bed Card

private struct BedCard: View {
    let bed: GardenBedData
    let onSlotTap: (Int, Int) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            bedHeader
            Divider().background(Color.white.opacity(0.08))
            BedGridView(bed: bed, onSlotTap: onSlotTap)
                .padding(12)
        }
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var bedHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(bed.name)
                    .font(.headline)
                    .fontDesign(.rounded)
                Text(bed.dimensionLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1), in: Circle())
                }
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 32, height: 32)
                        .background(Color.red.opacity(0.15), in: Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Bed Grid View

private struct BedGridView: View {
    let bed: GardenBedData
    let onSlotTap: (Int, Int) -> Void

    private let spacing: CGFloat = 4
    private let minCellSize: CGFloat = 36

    var body: some View {
        GeometryReader { proxy in
            let available = proxy.size.width - spacing * CGFloat(bed.widthFeet - 1)
            let cellSize = max(minCellSize, available / CGFloat(bed.widthFeet))
            VStack(spacing: spacing) {
                ForEach(0 ..< bed.heightFeet, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0 ..< bed.widthFeet, id: \.self) { col in
                            SlotCell(
                                slot: bed.slotAt(row: row, col: col),
                                size: cellSize,
                                onTap: { onSlotTap(row, col) }
                            )
                        }
                    }
                }
            }
        }
        .frame(height: gridHeight)
    }

    private var gridHeight: CGFloat {
        minCellSize * CGFloat(bed.heightFeet) + spacing * CGFloat(bed.heightFeet - 1)
    }
}

// MARK: - Slot Cell

private struct SlotCell: View {
    let slot: PlantSlot
    let size: CGFloat
    let onTap: () -> Void

    private static let emptyFill = Color(red: 0.13, green: 0.18, blue: 0.11)

    private var accessibilityLabel: String {
        guard !slot.isEmpty else { return "Empty slot" }
        let name = slot.plantName ?? slot.plantType?.displayName ?? "plant"
        return "Planted: \(name)"
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(slot.isEmpty ? Self.emptyFill : slot.slotColor)
                if slot.isEmpty {
                    SeedingPattern()
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } else {
                    Text(slot.plantType?.emoji ?? "")
                        .font(.system(size: size * 0.52))
                }
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 0.5)
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Tap to plant")
    }
}

// MARK: - Seeding Pattern

private struct SeedingPattern: View {
    var body: some View {
        Canvas { context, size in
            let dotRadius: CGFloat = 1.2
            let spacing: CGFloat = 8.0
            var xPos: CGFloat = spacing / 2
            while xPos < size.width {
                var yPos: CGFloat = spacing / 2
                while yPos < size.height {
                    let rect = CGRect(
                        x: xPos - dotRadius,
                        y: yPos - dotRadius,
                        width: dotRadius * 2,
                        height: dotRadius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color(red: 0.32, green: 0.38, blue: 0.27).opacity(0.55))
                    )
                    yPos += spacing
                }
                xPos += spacing
            }
        }
    }
}

// MARK: - Bed Preview Mini

private struct BedPreviewMini: View {
    let widthFeet: Int
    let heightFeet: Int

    private let cellSize: CGFloat = 10
    private let spacing: CGFloat = 2

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0 ..< min(heightFeet, 10), id: \.self) { _ in
                HStack(spacing: spacing) {
                    ForEach(0 ..< min(widthFeet, 12), id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(Color(red: 0.13, green: 0.18, blue: 0.11))
                            .overlay(
                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 0.5)
                            )
                            .frame(width: cellSize, height: cellSize)
                    }
                    if widthFeet > 12 {
                        Text("…").font(.system(size: 8)).foregroundStyle(.secondary)
                    }
                }
            }
            if heightFeet > 10 {
                Text("…").font(.system(size: 8)).foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - Add Bed Sheet

private struct AddBedSheet: View {
    let bedNumber: Int
    let onCreate: (String, Int, Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var widthFeet: Int = 4
    @State private var heightFeet: Int = 8

    var body: some View {
        NavigationStack {
            Form {
                Section("Bed Details") {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Bed \(bedNumber)", text: $name)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                }
                Section {
                    Stepper("Width: \(widthFeet) ft", value: $widthFeet, in: 1 ... 12)
                    Stepper("Length: \(heightFeet) ft", value: $heightFeet, in: 1 ... 20)
                } header: {
                    Text("Dimensions")
                } footer: {
                    Text("\(widthFeet * heightFeet) square feet total")
                }
                Section("Preview") {
                    HStack {
                        Spacer()
                        BedPreviewMini(widthFeet: widthFeet, heightFeet: heightFeet)
                        Spacer()
                    }
                    .listRowBackground(Color.white.opacity(0.04))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("New Bed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        let resolved = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? "Bed \(bedNumber)"
                            : name.trimmingCharacters(in: .whitespacesAndNewlines)
                        onCreate(resolved, widthFeet, heightFeet)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium])
    }
}

// MARK: - Edit Bed Sheet

private struct EditBedSheet: View {
    let initial: GardenBedData
    let onSave: (GardenBedData) -> Void
    let onCancel: () -> Void

    @State private var name: String
    @State private var widthFeet: Int
    @State private var heightFeet: Int

    init(initial: GardenBedData, onSave: @escaping (GardenBedData) -> Void, onCancel: @escaping () -> Void) {
        self.initial = initial
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: initial.name)
        _widthFeet = State(initialValue: initial.widthFeet)
        _heightFeet = State(initialValue: initial.heightFeet)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Bed Details") {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Bed name", text: $name)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }
                }
                Section {
                    Stepper("Width: \(widthFeet) ft", value: $widthFeet, in: 1 ... 12)
                    Stepper("Length: \(heightFeet) ft", value: $heightFeet, in: 1 ... 20)
                } header: {
                    Text("Dimensions")
                } footer: {
                    Text("\(widthFeet * heightFeet) sq ft — shrinking removes plants in trimmed cells")
                }
                Section("Preview") {
                    HStack {
                        Spacer()
                        BedPreviewMini(widthFeet: widthFeet, heightFeet: heightFeet)
                        Spacer()
                    }
                    .listRowBackground(Color.white.opacity(0.04))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Edit Bed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        var updated = initial
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        updated.name = trimmed.isEmpty ? initial.name : trimmed
                        updated.resize(width: widthFeet, height: heightFeet)
                        onSave(updated)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium])
    }
}

// MARK: - Plant Slot Picker Sheet

private struct PlantSlotPickerSheet: View {
    let current: PlantSlot
    let onPick: (PlantSlot) -> Void
    let onClear: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                if !current.isEmpty {
                    Section {
                        Button(role: .destructive) {
                            onClear()
                            dismiss()
                        } label: {
                            Label("Clear slot", systemImage: "xmark.circle")
                        }
                    }
                }
                Section("Choose a plant type") {
                    ForEach(PlantType.allCases, id: \.self) { type in
                        Button {
                            let slot = PlantSlot(plantName: type.displayName, plantTypeRaw: type.rawValue)
                            onPick(slot)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Text(type.emoji)
                                    .font(.title3)
                                    .frame(width: 32)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(type.displayName)
                                        .foregroundStyle(.primary)
                                    Text(type.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if current.plantType == type {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.cultivationGreen)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(current.isEmpty ? "What's here?" : "Change plant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
    }
}
