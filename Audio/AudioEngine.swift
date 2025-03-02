//

import Foundation
import AVFoundation
import SoundAnalysis


///// An observer that receives results from a classify sound request.
class ResultsObserver: NSObject, SNResultsObserving {
    /// Notifies the observer when a request generates a prediction.
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else { return }
        guard let classification = result.classifications.first else { return }
        // Get all classifications
        let classifications = result.classifications
        guard !classifications.isEmpty else { return }

        // Get the starting timea.
        let timeInSeconds = result.timeRange.start.seconds
        let formattedTime = String(format: "%.2f", timeInSeconds)

        // Print all classifications
        for classification in classifications {
            let percent = classification.confidence * 100.0
            let percentString = String(format: "%.2f%%", percent)
            //print("\(classification.identifier): \(percentString) confidence.\n")
        }

        // Create a dictionary with all classification results
        let classificationData = classifications.reduce(into: [String: Float]()) { dict, classification in
            dict[classification.identifier] = Float(classification.confidence)
        }
        let identifier = classification.identifier
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name("StutterResult"),
                object: identifier,
                userInfo: ["classifications": classificationData]
            )
        }
    }


    /// Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }


    /// Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
}

class Recorder {
    let soundClassifier = try! StutterDetector(configuration: MLModelConfiguration())
    let engine = AVAudioEngine()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    func setup() {
        inputFormat = engine.inputNode.inputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        startCapturingAudio()
    }
    
    func start() {
        do {
            try engine.start()
        } catch {
            print("Failed to start the engine")
        }
    }
    
    func stop() {
        engine.stop()
    }
    
    func toggle() {
        if !engine.isRunning {
            start()
        } else {
            stop()
        }
    }
    
    private func startCapturingAudio() {
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try analyzer.add(request, withObserver: resultsObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
        
        engine.inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { buffer, time in
            
            let channelDataValue = buffer.floatChannelData!.pointee
            let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map{ channelDataValue[$0] }
            
            let rms = sqrt(channelDataValueArray.map{ $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            let avgPower = 20 * log10(rms)
            if avgPower > -30.0 {
                self.analysisQueue.async {
                    self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
            }
        }
    }
}
