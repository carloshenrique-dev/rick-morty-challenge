import SwiftUI

struct PortalLoadingView: View {
    @State private var isRotating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.green, .mint, .green]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [10, 20])
                )
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 2)
                        .repeatForever(autoreverses: false),
                    value: isRotating
                )
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.8), Color.black]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 40, height: 40)
                .scaleEffect(isRotating ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: isRotating
                )
        }
        .onAppear {
            isRotating = true
        }
    }
}

struct PortalLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PortalLoadingView()
            .preferredColorScheme(.dark)
    }
}
