//
//  AudioRecorder2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  recorder2.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//
//fdsaf

import Foundation
import SwiftUI
import AVFoundation
import Combine
import AVFoundation
import CoreML
class AudioRecorder2: NSObject, ObservableObject {
    
    var audioRecorder: AVAudioRecorder?
    @Published private var recordingName = "Recording1"
    @Published private var recordingDate = Date()
    @Published private var recordingURL: URL?
    @Published var isRecording = false
    
    // MARK: - Start Recording
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            print("Start Recording - Recording session setted")
        } catch {
            print("Start Recording - Failed to set up recording session")
        }
        
        let currentDateTime = Date.now
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // Ensures consistent formatting
        dateFormatter.dateFormat = "MMMM, d yyyy 'at' h:mm:ss a"
        recordingName = dateFormatter.string(from: currentDateTime)

        
        // save the recording to the temporary directory
        let tempDirectory = FileManager.default.temporaryDirectory
        let recordingFileURL = tempDirectory.appendingPathComponent(recordingName).appendingPathExtension("m4a")
        recordingURL = recordingFileURL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingFileURL, settings: settings)
            audioRecorder?.record()
            
            withAnimation {
                isRecording = true
            }
            print("Start Recording - Recording Started")
        } catch {
            print("Start Recording - Could not start recording")
        }
    }
    
    // MARK: - Stop Recording
    
    @MainActor func stopRecording() {
        audioRecorder?.stop()
        withAnimation {
            isRecording = false
        }
        
        if let recordingURL = recordingURL {
            do {
                let recordingData = try Data(contentsOf: recordingURL)
                print("Stop Recording - Saving recording as object of Recording2")
                // save the recording as object of Recording2
                saveRecording(recordingData: recordingData)
                // do something with the recording object
                
                // Convert Audio to MLMultiArray
                let audioFile = try AVAudioFile(forReading: recordingURL)
                let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: UInt32(audioFile.length))
                try audioFile.read(into: pcmBuffer!)
                
                let audioData = try MLMultiArray(shape: [48000], dataType: MLMultiArrayDataType.float32)
                for i in 0..<48000 {
                    audioData[i] = NSNumber(value: Float(pcmBuffer!.floatChannelData!.pointee[i]))
                }
                
                // Make Prediction
                let model = try StutterDetector()
               let output = try model.prediction(audioSamples: audioData)
                
//                 Handle Prediction
                print(output)
              //  print("Predicted target: \(output)")
              //  Manager.shared.actionStream.send(Probability(dict:output.targetProbability, predicted: output.target))
              //  print("Probability: \(output.targetProbability)")
                
                // delete the recording stored in the temporary directory
                deleteRecordingFile()
            } catch {
                print("Stop Recording - Could not save recording as object of Recording2 - Cannot get the recording data from URL: \(error)")
            }
            
        } else {
            print("Stop Recording -  Could not save recording as object of Recording2 - Cannot find the recording URL")
        }
        
    }
    @MainActor func saveRecording(recordingData: Data){
        let new = Recording2(createdAt: recordingDate, id: UUID(), name: recordingName, recordingData: recordingData)
        Manager.shared.recordStream.send(new)
    }
    
    func deleteRecordingFile() {
        if let recordingURL = recordingURL {
            do {
                try FileManager.default.removeItem(at: recordingURL)
                print("Stop Recording - Successfully deleted the recording file")
            } catch {
                print("Stop Recording - Could not delete the recording file - Cannot find the recording URL")
            }
        }
    }
    
}
