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

