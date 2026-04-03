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



Info.plist 必须添加的权限（Xcode → 项目 → Info）
<key>NSCameraUsageDescription</key>
<string>境音需要使用相机生成 AR 音灵</string>
<key>NSMicrophoneUsageDescription</key>
<string>用于实时空间音频采集</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>保存音景位置</string>
<key>NSHealthShareUsageDescription</key>
<string>读取心率生成个性化音乐</string>
<key>NSHealthUpdateUsageDescription</key>
<string>读取心率生成个性化音乐</string>

<key>NSAppleIntelligenceUsageDescription</key>
<string>使用 Apple Intelligence 生成个性化音乐和提示词</string>
<key>RPScreenRecorderUsageDescription</key>
<string>录制 AR 音景视频</string>





Xcode 项目已打包成「GitHub 风格」结构
RealmSound/
├── README.md
├── .gitignore
├── RealmSound.xcodeproj/          # Xcode 会自动生成
├── RealmSound/
│   ├── RealmSoundApp.swift
│   ├── ContentView.swift
│   ├── ARCameraView.swift
│   ├── ARViewContainer.swift
│   ├── LaunchScreen.swift
│   ├── PersistenceController.swift
│   ├── Models/
│   │   ├── Soundscape.swift
│   │   └── CapturedSpirit.swift
│   ├── Services/
│   │   ├── AppleIntelligenceService.swift
│   │   ├── ARManager.swift
│   │   └── VideoExporter.swift
│   ├── Views/
│   │   ├── ControlPanel.swift
│   │   ├── CaptureButton.swift
│   │   ├── HeartRateView.swift
│   │   └── HistoryView.swift
│   └── Shaders/
│       └── GlowingParticle.metal     # ← 新增：超炫 Metal Shader
├── RealmSoundTests/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/           # 放入你之前生成的 Icon
│   ├── LaunchBackground.imageset/    # 放入你之前生成的启动页图
│   └── Contents.json
└── Info.plist

快速创建步骤（3 分钟）

Xcode 16+ → Create a new Xcode Project → App → SwiftUI + Swift
项目名填 RealmSound
开启 Capability：iCloud（CloudKit）、HealthKit、Background Modes（可选）
按照上面的目录结构新建文件夹和文件，复制下面代码
把之前我生成的 App Icon 和 LaunchBackground 图片拖入 Assets.xcassets
运行即可！

Shaders/GlowingParticle.metal
#include <metal_stdlib>
#include <RealityKit/RealityKit.h>
using namespace metal;

[[visible]]
half4 glowingParticleFragment(FragmentData frag [[stage_in]],
                              constant float &time [[buffer(0)]],
                              constant float &intensity [[buffer(1)]]) {
    
    // 核心：多层霓虹辉光 + 脉冲 + 彩虹呼吸
    float2 uv = frag.texcoord;
    float dist = length(uv - 0.5);
    
    // 脉冲主光
    float pulse = sin(time * 8.0) * 0.5 + 0.5;
    float glow = exp(-dist * 12.0) * pulse * intensity;
    
    // 外层 bloom
    float bloom = exp(-dist * 6.0) * 0.6;
    
    // 彩虹色相随时间流动
    float hue = fract(time * 0.3 + dist * 2.0);
    half3 rainbow = half3(sin(hue * 6.28 + 0.0),
                          sin(hue * 6.28 + 2.0),
                          sin(hue * 6.28 + 4.0));
    
    // 青紫霓虹主色
    half3 neon = mix(half3(0.0, 1.0, 1.0), rainbow, 0.4);
    
    // 最终颜色
    half3 color = neon * (glow + bloom * 1.4);
    
    // 透明度随脉冲变化
    half alpha = saturate(glow * 2.0 + 0.3);
    
    return half4(color * 3.0, alpha); // 超强辉光
}

// 可选的顶点动画（让粒子自己“呼吸”）
[[vertex]]
VertexOut glowingParticleVertex(VertexIn in [[stage_in]],
                                constant float &time [[buffer(0)]]) {
    VertexOut out;
    out.position = in.position;
    // 轻微缩放呼吸
    float scale = 1.0 + sin(time * 12.0) * 0.08;
    out.position.xyz *= scale;
    return out;
}

