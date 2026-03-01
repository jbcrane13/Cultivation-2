import SwiftUI

struct ScannerView: View {
    var body: some View {
        ZStack {
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
