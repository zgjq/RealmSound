
import SwiftUI
import AVFAudio
import AppleIntelligence // iOS 18.2+

@MainActor
class AppleIntelligenceService {
    static let shared = AppleIntelligenceService()
    private init() {}
    
    func generateMusicPrompt(from environment: String, heartRate: Int, intensity: Double) async throws -> String {
        // Apple Intelligence 生成提示词
        let prompt = """
        根据以下环境生成一段梦幻空间音乐描述：
        环境：\(environment)
        当前心率：\(heartRate) bpm
        情绪强度：\(Int(intensity * 100))%
        风格：赛博梦幻、日式治愈、AR 沉浸式
        """
        
        let response = try await WritingTools().generate(text: prompt, style: .creative)
        return response
    }
    
    func generateSpatialAudio(prompt: String) async throws -> URL {
        // 真实项目中可接入第三方 on-device 模型，这里用 AVAudioEngine 模拟生成
        let audioFile = FileManager.default.temporaryDirectory.appendingPathComponent("realmsound_\(UUID().uuidString).m4a")
        
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)
        
        // 模拟生成一段带空间感的音效（你可以替换为真实 AI 音频模型）
        let buffer = try await generateToneBuffer(duration: 15.0, prompt: prompt)
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        
        engine.connect(player, to: engine.mainMixerNode, format: buffer.format)
        try engine.start()
        player.play()
        
        // 15秒后停止并保存
        try await Task.sleep(for: .seconds(15))
        engine.stop()
        
        // 这里实际保存为文件（简化版）
        return audioFile // 真实项目使用 AVAssetWriter 写入
    }
    
    private func generateToneBuffer(duration: TimeInterval, prompt: String) async throws -> AVAudioPCMBuffer {
        // 简化音效生成（可替换为 MusicGen on-device 模型）
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount
        
        // 简单 sine wave + 随机 noise 模拟“梦幻音乐”
        for frame in 0..<Int(frameCount) {
            let value = sin(2 * Float.pi * Float(frame) / 200) * 0.8 + Float.random(in: -0.1...0.1)
            buffer.floatChannelData?[0][frame] = value
            buffer.floatChannelData?[1][frame] = value * 0.9
        }
        return buffer
    }
}
