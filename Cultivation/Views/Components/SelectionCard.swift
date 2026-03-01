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
