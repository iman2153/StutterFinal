//
//  ContentView2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//




import SwiftUI
import Combine

struct ContentView2: View {
    @ObservedObject var audioPlayer = AudioPlayer2()
    @State private var transcript = ""
    @State private var cancellables: Set<AnyCancellable> = []
    @State var predictions: [String: Double] = [:]
    @State var predicted: String = ""
    @State private var currentClassification = ""
    @ObservedObject var audioRecorder = AudioRecorder2()
    let speechRecognizer = SpeechRecognizer()
    @State private var isRecognizing = false
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            RecordingsList2(audioPlayer: audioPlayer)
            
            // Classification display
            HStack {
                Text("\(Image(systemName: "waveform")) Classification:")
                    .bold()
                Text(currentClassification)
                    .bold()
                    .foregroundColor(.blue)
            }
            .font(.title3)
            .padding(.top)
            
            // Transcript display
            let padding: CGFloat = 10
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 5)
                    .opacity(0.3)
                
                ScrollView {
                    if !transcript.isEmpty {
                        Text(transcript)
                            .padding(padding + 5)
                    } else if !isRecording {
                        Text("Press the record button to start.")
                            .foregroundColor(.secondary)
                            .padding(padding + 5)
                    } else {
                        Text("Begin speaking to start.")
                            .foregroundColor(.secondary)
                            .padding(padding + 5)
                    }
                }
            }
            .padding()
            
            // Record button
            RecordButtonView(isRecording: $isRecording) {
                toggleRecognizer()
            }
            .frame(height: 60)
            .scaleEffect(0.95)
            .padding()
            .background(Color.secondarySystemBackground)
            
            // Bottom bar
//            .safeAreaInset(edge: .bottom) {
//                bottomBar
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
           // print(result.object)
            if let classification = result.object as? String {
                self.currentClassification = classification
            }
        }
    }
    
    var bottomBar: some View {
        VStack {
            PlayerBar2(audioPlayer: audioPlayer)
            RecorderBar2(audioPlayer: audioPlayer)
        }
        .background(.thinMaterial)
    }
    
    func toggleRecognizer() {
        if isRecognizing {
            speechRecognizer.stopRecording()
            isRecognizing = false
        } else {
            speechRecognizer.record(to: $transcript)
            isRecognizing = true
        }
    }
}
