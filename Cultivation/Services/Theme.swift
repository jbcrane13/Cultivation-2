import SwiftUI

extension Color {
    static let cultivationGreen = Color(red: 0.157, green: 0.804, blue: 0.255)
    static let cultivationBackground = Color(red: 0.05, green: 0.08, blue: 0.05)
    static let surfaceWhite = Color.white.opacity(0.07)
    static let borderWhite = Color.white.opacity(0.1)
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }

    func darkBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [Color(red: 0.04, green: 0.08, blue: 0.04), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
