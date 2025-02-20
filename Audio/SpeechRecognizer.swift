import AVFoundation
import SwiftUI
import Foundation
import SoundAnalysis
import SwiftUICore

struct SpeechRecognizer {
    private class SpeechAssist {
        var audioEngine: AVAudioEngine?
        var resultsObserver = ResultsObserver()

        deinit {
            reset()
        }

        func reset() {
            audioEngine?.stop()
            audioEngine = nil
        }
    }

    private let assistant = SpeechAssist()

    func record(to speech: Binding<String>) {
        relay(speech, message: "Requesting access")
        canAccess { authorized in
            guard authorized else {
                relay(speech, message: "Access denied")
                return
            }

            relay(speech, message: "Access granted")

            assistant.audioEngine = AVAudioEngine()
            guard let audioEngine = assistant.audioEngine else {
                fatalError("Unable to create audio engine")
            }

            do {
                relay(speech, message: "Booting audio subsystem")

                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                let inputNode = audioEngine.inputNode
                relay(speech, message: "Found input node")

                let inputFormat = inputNode.inputFormat(forBus: 0)
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                
                let soundClassifier = try StutterDetector(configuration: MLModelConfiguration())
                
                let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
                let analyzer = SNAudioStreamAnalyzer(format: inputFormat)
                try analyzer.add(request, withObserver: assistant.resultsObserver)
                
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                    DispatchQueue(label: "com.apple.AnalysisQueue").async {
                        analyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
                    }
                }
                
                relay(speech, message: "Preparing audio engine")
                audioEngine.prepare()
                try audioEngine.start()
                relay(speech, message: "")
            } catch {
                print("Error analyzing audio: " + error.localizedDescription)
                assistant.reset()
            }
        }
    }
    
    func stopRecording() {
        assistant.reset()
    }
    
    private func canAccess(withHandler handler: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { authorized in
            handler(authorized)
        }
    }
    
    private func relay(_ binding: Binding<String>, message: String) {
        DispatchQueue.main.async {
            binding.wrappedValue = message
        }
    }
}
