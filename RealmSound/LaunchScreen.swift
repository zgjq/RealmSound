import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            // 背景使用你之前生成的启动页图片（拖入 Assets）
            Image("LaunchBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("境音")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(.white.shadow(.drop(radius: 20)))
                Text("RealmSound")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.9))
                
                // 加载动画（pulse waveform）
                AudioWaveformView()
            }
        }
    }
}

struct AudioWaveformView: View {
    @State private var phase: CGFloat = 0
    var body: some View {
        Canvas { context, size in
            let path = Path { p in
                for x in stride(from: 0, to: size.width, by: 8) {
                    let y = sin((x / size.width) * .pi * 4 + phase) * 30 + size.height / 2
                    p.addLine(to: CGPoint(x: x, y: y))
                }
            }
            context.stroke(path, with: .color(.cyan), lineWidth: 4)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

