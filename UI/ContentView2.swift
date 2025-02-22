//
//  ContentView2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//




import SwiftUI
import Combine

struct ContentView2: View {
    #if DEBUG
    @State private var showWhatsNew = true
    #else
    @AppStorage("hasSeenWhatsNew") private var showWhatsNew = false
    #endif
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
        
//            
//            // Record button
//            RecordButtonView(isRecording: $isRecording) {
//                toggleRecognizer()
//            }
//            .scaleEffect(0.95)
//            .padding()
//            .background(Color.secondarySystemBackground)
            
            // Bottom bar
            .safeAreaInset(edge: .bottom) {
                HStack{
                    Spacer()
                    newBottomBar
                    Spacer()
                }
            }
        }
        .onAppear {
#if !DEBUG
            if !showWhatsNew {
                showWhatsNew = true
            }
#endif
        }
                .sheet(isPresented: $showWhatsNew) {
                    WhatsNewView(isPresented: $showWhatsNew)
                }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
           // print(result.object)
            if let classification = result.object as? String {
                self.currentClassification = classification
            }
        }
    }
    var newBottomBar: some View {
            
            RecordButtonView(isRecording: $isRecording) {
                toggleRecognizer()
            }
                    .scaleEffect(0.95)
                    .padding()
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
            audioRecorder.stopRecording()
            isRecognizing = false
        } else {
            audioRecorder.startRecording()
            speechRecognizer.record(to: $transcript)
            isRecognizing = true
        }
    }
}
