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
    @State private var starRotating = false
    
    var body: some View {
        ZStack {
            // 树干
            Rectangle()
                .fill(Color.brown)
                .frame(width: 30, height: 50)
                .offset(y: 120)
            
            // 树的层次 - 从下到上
            Group {
                Triangle()
                    .fill(Color.green)
                    .frame(width: 200, height: 100)
                    .offset(y: 70)
                
                Triangle()
                    .fill(Color.green)
                    .frame(width: 160, height: 90)
                    .offset(y: 30)
                
                Triangle()
                    .fill(Color.green)
                    .frame(width: 120, height: 80)
                    .offset(y: -10)
                
                Triangle()
                    .fill(Color.green)
                    .frame(width: 80, height: 70)
                    .offset(y: -40)
            }
            
            // 顶部星星
            Image(systemName: "star.fill")
                .font(.system(size: 30))
                .foregroundColor(.yellow)
                .offset(y: -80)
                .rotationEffect(.degrees(starRotating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false),
                    value: starRotating
                )
            
            // 圣诞球装饰
            ForEach(0..<20) { i in
                Circle()
                    .fill(
                        Color(
                            red: Double.random(in: 0.5...1),
                            green: Double.random(in: 0.5...1),
                            blue: Double.random(in: 0.5...1)
                        )
                    )
                    .frame(width: CGFloat.random(in: 8...15), height: CGFloat.random(in: 8...15))
                    .offset(
                        x: CGFloat.random(in: -80...80),
                        y: CGFloat.random(in: -60...100)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
            }
            
            // 小灯泡
            ForEach(0..<15) { i in
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(
                        [Color.yellow, Color.red, Color.blue, Color.green]
                            .randomElement()
                    )
                    .opacity(isAnimating ? 1 : 0.3)
                    .offset(
                        x: CGFloat.random(in: -70...70),
                        y: CGFloat.random(in: -50...90)
                    )
            }
            
            // 彩带
            ForEach(0..<8) { i in
                Path { path in
                    path.move(to: CGPoint(x: -40 + Double(i) * 10, y: -60 + Double(i) * 20))
                    path.addQuadCurve(
                        to: CGPoint(x: 40 - Double(i) * 10, y: -60 + Double(i) * 20),
                        control: CGPoint(x: 0, y: -40 + Double(i) * 20)
                    )
                }
                .stroke(
                    Color(
                        red: Double.random(in: 0.5...1),
                        green: Double.random(in: 0.5...1),
                        blue: Double.random(in: 0.5...1)
                    ),
                    lineWidth: 2
                )
            }
        }
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
            starRotating = true
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
