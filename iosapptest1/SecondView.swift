import SwiftUI

struct SnowflakeView: View {
    let size: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: size, height: size)
            .opacity(0.7)
            .offset(y: isAnimating ? 1000 : -100)
            .animation(
                Animation.linear(duration: Double.random(in: 5...10))
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct ChristmasTreeView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 树
            Triangle()
                .fill(Color.green)
                .frame(width: 150, height: 200)
            
            // 装饰品
            ForEach(0..<10) { i in
                Circle()
                    .fill(Color(
                        red: Double.random(in: 0.5...1),
                        green: Double.random(in: 0.5...1),
                        blue: Double.random(in: 0.5...1)
                    ))
                    .frame(width: 10, height: 10)
                    .offset(
                        x: CGFloat.random(in: -60...60),
                        y: CGFloat.random(in: -80...80)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
            }
        }
        .animation(
            Animation.easeInOut(duration: 1.0).repeatForever(),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct SecondView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // 雪花
            ForEach(0..<50) { _ in
                SnowflakeView(size: CGFloat.random(in: 5...15))
                    .offset(x: CGFloat.random(in: -200...200))
            }
            
            VStack {
                // 祝福文字
                Text("祝婷玉")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                
                Text("圣诞快乐")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                
                // 圣诞树
                ChristmasTreeView()
                    .padding(.top, 30)
                
                // 礼物盒
                Image(systemName: "gift.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
                    .padding(.top, 30)
            }
        }
        .animation(
            Animation.easeInOut(duration: 1.5).repeatForever(),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    NavigationStack {
        SecondView()
    }
} 
