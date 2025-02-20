//import SwiftUI
//import Combine
//import Foundation
//
//struct ContentView3: View {
//    @ObservedObject var audioPlayer = AudioPlayer2()
//    @ObservedObject var audioRecorder = AudioRecorder2()
//    
//    @State private var cancellables: Set<AnyCancellable> = []
//    @State var predictions: [String: Double] = [:]
//    @State var predicted: String = ""
//    @State private var transcript = ""
//    @State private var isRecognizing = false
//    @State private var isRecording = false
//    @State private var currentClassification = ""
//    
//    let speechRecognizer = SpeechRecognizer()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                RecordingsList2(audioPlayer: audioPlayer)
//                VStack {
//                    ForEach(predictions.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
//                        HStack {
//                            switch key {
//                            case "NoStutteredWords":
//                                Text("No Stutters:")
//                            case "SoundRep":
//                                Text("Sound Repetition:")
//                            case "WordRep":
//                                Text("Word Repetition:")
//                            default:
//                                Text("\(key):")
//                            }
//                            Spacer()
//                            Text("\(Int(value * 100.rounded()))%")
//                        }
//                    }
//                }
//                .padding()
//                
//                HStack {
//                    Text("\(Image(systemName: "waveform")) Classification:")
//                        .bold()
//                    Text(currentClassification)
//                        .bold()
//                        .foregroundColor(.blue)
//                }
//                .font(.title3)
//                .padding(.top)
//                
//                let padding: CGFloat = 10
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.blue, lineWidth: 5)
//                        .opacity(0.3)
//                    
//                    ScrollView {
//                        if !transcript.isEmpty {
//                            Text(transcript)
//                                .padding(padding + 5)
//                        } else if !isRecording {
//                            Text("Press the record button to start.")
//                                .foregroundColor(.secondary)
//                                .padding(padding + 5)
//                        } else {
//                            Text("Begin speaking to start.")
//                                .foregroundColor(.secondary)
//                                .padding(padding + 5)
//                        }
//                    }
//                }
//                .padding()
//                
//                Button(action: {
//                    toggleRecognizer()
//                }) {
//                    Text(isRecognizing ? "Stop Recording" : "Start Recording")
//                        .padding()
//                        .background(isRecognizing ? Color.red : Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//                
//                .safeAreaInset(edge: .bottom) {
//                    bottomBar
//                }
//            }
//            .onAppear {
//                subscribe()
//            }
//            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
//                if let classification = result.object as? String {
//                    self.currentClassification = classification
//                }
//            }
//            .navigationTitle("StutterAI")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//    
//    var bottomBar: some View {
//        VStack {
//            PlayerBar2(audioPlayer: audioPlayer)
//            RecorderBar2(audioPlayer: audioPlayer)
//        }
//        .background(.thinMaterial)
//    }
//    
//    func subscribe() {
//        Manager.shared.actionStream
//            .receive(on: DispatchQueue.main)
//            .sink { [self] action in
//                self.predicted = action.predicted
//                self.predictions = action.dict
//            }
//            .store(in: &cancellables)
//    }
//    
//    func toggleRecognizer() {
//        if isRecognizing {
//            audioRecorder.stopRecording()
//            speechRecognizer.stopRecording()
//            isRecognizing = false
//        } else {
//            audioRecorder.startRecording()
//            speechRecognizer.record(to: $transcript)
//            isRecognizing = true
//        }
//    }
//}
