import SwiftUI

struct CharacterRowSkeleton: View {
    @State private var isShimmering = false
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 40)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .opacity(isShimmering ? 0.5 : 1.0)
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ) {
                isShimmering = true
            }
        }
    }
}
