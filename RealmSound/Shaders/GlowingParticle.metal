#include <metal_stdlib>
using namespace metal;

// MARK: - Glowing Particle Shader
// A mesmerizing particle effect with soft glow and color shifting

struct ParticleVertex {
    float3 position [[attribute(0)]];
    float4 color [[attribute(1)]];
    float size [[attribute(2)]];
    float life [[attribute(3)]];
};

struct ParticleOut {
    float4 position [[position]];
    float4 color;
    float size;
    float life;
};

// MARK: - Vertex Shader

vertex ParticleOut particleVertex(
    uint vertexID [[vertex_id]],
    constant ParticleVertex *particles [[buffer(0)]],
    constant float4x4 &modelViewProjectionMatrix [[buffer(1)]],
    constant float &time [[buffer(2)]]
) {
    ParticleVertex particle = particles[vertexID];
    
    // Animate particle position with gentle floating motion
    float3 animatedPosition = particle.position;
    animatedPosition.y += sin(time * 2.0 + particle.life * 6.28) * 0.1;
    animatedPosition.x += cos(time * 1.5 + particle.life * 3.14) * 0.05;
    
    ParticleOut out;
    out.position = modelViewProjectionMatrix * float4(animatedPosition, 1.0);
    out.color = particle.color;
    out.size = particle.size * (1.0 - particle.life * 0.5); // Shrink over lifetime
    out.life = particle.life;
    
    return out;
}

// MARK: - Fragment Shader

fragment float4 particleFragment(
    ParticleOut in [[stage_in]],
    texture2d<float> glowTexture [[texture(0)]]
) {
    // Create soft radial gradient for glow
    float2 coord = in.position.xy;
    float dist = length(coord);
    float radius = in.size;
    
    // Soft edge glow
    float alpha = smoothstep(radius, radius * 0.3, dist);
    
    // Color shift based on life
    float3 baseColor = in.color.rgb;
    float3 glowColor = mix(baseColor, float3(1.0, 0.8, 1.0), in.life * 0.5);
    
    // Add pulsing glow effect
    float pulse = 0.8 + 0.2 * sin(in.life * 12.0);
    
    return float4(glowColor * pulse, alpha * in.color.a);
}

// MARK: - Background Shader (Ethereal Realm Effect)

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex VertexOut backgroundVertex(
    uint vertexID [[vertex_id]],
    constant float4x4 &projectionMatrix [[buffer(0)]]
) {
    VertexOut out;
    
    // Full-screen quad vertices
    float2 positions[6];
    positions[0] = float2(-1, -1);
    positions[1] = float2( 1, -1);
    positions[2] = float2(-1,  1);
    positions[3] = float2(-1,  1);
    positions[4] = float2( 1, -1);
    positions[5] = float2( 1,  1);
    
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.uv = positions[vertexID] * 0.5 + 0.5;
    
    return out;
}

fragment float4 backgroundFragment(
    VertexOut in [[stage_in]],
    constant float &time [[buffer(0)]]
) {
    // Ethereal realm background with flowing colors
    float2 uv = in.uv;
    
    // Flowing noise-like pattern
    float n1 = sin(uv.x * 3.14 + time * 0.5) * 0.5 + 0.5;
    float n2 = cos(uv.y * 2.71 + time * 0.3) * 0.5 + 0.5;
    float n3 = sin((uv.x + uv.y) * 4.0 + time * 0.7) * 0.5 + 0.5;
    
    // Purple-blue ethereal color palette
    float3 color1 = float3(0.2, 0.0, 0.4);  // Deep purple
    float3 color2 = float3(0.0, 0.1, 0.5);  // Deep blue
    float3 color3 = float3(0.4, 0.0, 0.3);  // Magenta
    
    float3 finalColor = mix(color1, color2, n1);
    finalColor = mix(finalColor, color3, n2 * 0.3);
    finalColor += n3 * 0.05;
    
    // Vignette
    float vignette = 1.0 - length(uv - 0.5) * 0.8;
    finalColor *= vignette;
    
    return float4(finalColor, 1.0);
}

// MARK: - Spirit Aura Shader (Halo Effect)

fragment float4 spiritAuraFragment(
    ParticleOut in [[stage_in]],
    constant float &time [[buffer(0)]]
) {
    float2 coord = in.position.xy;
    float dist = length(coord);
    float radius = in.size * 1.5;
    
    // Multiple ring halo
    float ring1 = smoothstep(radius, radius * 0.8, dist) - smoothstep(radius * 0.8, radius * 0.6, dist);
    float ring2 = smoothstep(radius * 0.6, radius * 0.4, dist) - smoothstep(radius * 0.4, radius * 0.2, dist);
    float core = smoothstep(radius * 0.3, 0.0, dist);
    
    float alpha = ring1 * 0.3 + ring2 * 0.5 + core * 0.8;
    
    // Rotating color
    float angle = atan2(coord.y, coord.x);
    float colorShift = sin(angle * 3.0 + time * 2.0) * 0.5 + 0.5;
    
    float3 auraColor = mix(
        float3(0.6, 0.2, 1.0),  // Purple
        float3(0.2, 0.8, 1.0),  // Cyan
        colorShift
    );
    
    // Pulsing
    float pulse = 0.7 + 0.3 * sin(time * 4.0);
    
    return float4(auraColor * pulse, alpha * pulse);
}
