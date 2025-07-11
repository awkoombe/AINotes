import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating = false
    let color: Color
    
    init(color: Color = .white) {
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                    .scaleEffect(isAnimating ? 0.5 : 1)
                    .opacity(isAnimating ? 0.3 : 1)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    ZStack {
        Color.black
        LoadingIndicator()
    }
} 
