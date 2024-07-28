import SwiftUI

struct DotShape: View {
    @Binding var dots: [Dot]
    
    var body: some View {
        ZStack {
            ForEach(dots) { dot in
                Circle()
                    .fill(dot.color)
                    .frame(width: dot.size, height: dot.size)
                    .position(x: dot.x, y: dot.y)
            }
        }
        .onAppear {
            startRandomMovement()
        }
    }
    
    func startRandomMovement() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                for index in dots.indices {
                    dots[index].x += CGFloat.random(in: -0.1...0.1)
                    dots[index].y += CGFloat.random(in: -0.1...0.1)
                }
            }
        }
    }
}

struct DotShape_Previews: PreviewProvider {
    static var previews: some View {
        DotShape(dots: .constant([]))
    }
}
