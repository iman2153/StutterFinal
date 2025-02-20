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
    
    @State private var cancellables: Set < AnyCancellable> = []
    @State var predictions: [String: Double] = [:]
    @State var predicted: String = ""
    
    @ObservedObject var audioRecorder = AudioRecorder2()
    
    
    var body: some View {
        VStack {
            RecordingsList2(audioPlayer: audioPlayer)
            VStack {
                ForEach(predictions.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                    HStack {
                        switch key {
                        case "NoStutteredWords":
                            Text("No Stutters:")
                        case "SoundRep":
                            Text("Sound Repetition:")
                        case "WordRep":
                            Text("Word Repetition:")
                        default:
                            Text("\(key):")
                        }
                        Spacer()
                        Text("\(Int(value*100.rounded()))%")
                    }
                }
            }
                .safeAreaInset(edge: .bottom) {
                    bottomBar
                }
            
        }
        .onAppear{
            subscribe()
        }

    }
        
    var bottomBar: some View {
        VStack {
            PlayerBar2(audioPlayer: audioPlayer)
            RecorderBar2(audioPlayer: audioPlayer)
        }
        .background(.thinMaterial)
    }
    func subscribe() {
        Manager.shared.actionStream
            .receive(on: DispatchQueue.main)
            .sink { [self] action in
                self.predicted = action.predicted
                self.predictions = action.dict
            }
            .store(in: &cancellables)
    }
    
}

