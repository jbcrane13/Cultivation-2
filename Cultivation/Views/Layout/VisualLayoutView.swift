import SwiftUI

struct VisualLayoutView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Greenhouse Layout")
                    .font(.headline)
                    .padding()

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                    spacing: 10
                ) {
                    ForEach(0..<9, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(index == 4 ? Color.green.opacity(0.3) : Color(UIColor.tertiarySystemFill))
                            .frame(height: 100)
                            .overlay(
                                index == 4
                                    ? Image(systemName: "leaf.fill").foregroundColor(.green)
                                    : nil
                            )
                    }
                }
                .padding()

                Spacer()

                Button {} label: {
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
