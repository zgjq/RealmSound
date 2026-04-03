import RealityKit
import ReplayKit

class VideoExporter {
    func start15SecondARRecording(in arView: ARView, completion: @escaping (URL?) -> Void) async {
        let recorder = RPScreenRecorder.shared()
        guard recorder.isAvailable else { return }
        
        do {
            try await recorder.startRecording(withMicrophoneEnabled: true)
            try await Task.sleep(for: .seconds(15))
            let preview = try await recorder.stopRecording()
            // 真实项目可保存到相册或返回 URL
            completion(nil) // 这里可扩展返回视频 URL
            preview.previewController().show(in: UIApplication.shared.windows.first!)
        } catch { print("导出失败") }
    }
}


