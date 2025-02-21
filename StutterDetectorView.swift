import SwiftUI
import Foundation

struct StutterDetectorView: View {
    let speechRecognizer = SpeechRecognizer()
    @State private var transcript = ""
    @State private var isRecognizing = false
    
    @State private var isRecording = false
    @State private var currentClassification = ""
    
    var body: some View {
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
                HStack{
                    Spacer()
                }
                RecordButtonView(isRecording: $isRecording) {
                    toggleRecognizer()
                }
                Spacer()
                .frame(height: 60)
                .scaleEffect(0.95)
                .padding()
                .background(Color.secondarySystemBackground)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("StutterResult"))) { result in
                print("Received notification with userInfo:", result.userInfo ?? "nil")
                if let userInfo = result.userInfo,
                   let classifications = userInfo["classifications"] as? [String: Float],
                   let highestConfidence = classifications.max(by: { $0.value < $1.value }) {
                    print("Classifications:", classifications)
                    print("Highest confidence:", highestConfidence)
                    self.currentClassification = highestConfidence.key
                }
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
