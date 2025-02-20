import SwiftUI
import Foundation

struct StutterDetectorView: View {
    let speechRecognizer = SpeechRecognizer()
    @State private var transcript = ""
    @State private var isRecognizing = false
    
    @State private var isRecording = false
    @State private var currentClassification = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Text("\(Image(systemName: "waveform")) Classification:")
                            .bold()
                        Text(currentClassification)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .font(.title3)
                    .padding(.top)
                    
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
                }
                .padding(.top)
                
                RecordButtonView(isRecording: $isRecording) {
                    toggleRecognizer()
                }
                .frame(height: 60)
                .scaleEffect(0.95)
                .padding()
                .background(Color.secondarySystemBackground)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
                if let classification = result.object as? String {
                    self.currentClassification = classification
                }
            }
            .navigationTitle("StutterAI")
            .navigationBarTitleDisplayMode(.inline)
        }
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
