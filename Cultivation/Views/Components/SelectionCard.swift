import SwiftUI

struct SelectionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontDesign(.rounded)
                    .foregroundStyle(isSelected ? Color.black : Color.primary)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.black : Color.white.opacity(0.3))
                    .font(.title3)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.cultivationGreen : Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? Color.clear : Color.white.opacity(0.1),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected ? Color.cultivationGreen.opacity(0.35) : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
    }
}
