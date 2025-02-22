//
//  RecordingsList2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  rlist2.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//


import SwiftUI
import AVFoundation
import Combine

struct RecordingsList2: View {
    @ObservedObject var audioPlayer: AudioPlayer2
    @State var cancellables: Set<AnyCancellable> = []
    @State var recordings: [Recording2] = []
    var body: some View {
        List {
            ForEach(recordings, id: \.id) { recording in
                RecordingRow2(audioPlayer: audioPlayer, recording: recording)
            }
                .onDelete(perform: delete)
        }
        .onAppear{
            sub()
        }
    }
       
    
    func delete(at offsets: IndexSet) {
        recordings.remove(atOffsets: offsets)
    }
    func sub(){
        Manager.shared.recordStream
            .receive(on: DispatchQueue.main)
            .sink { [self] action in
                self.recordings.append(action)
            }
            .store(in: &cancellables)
    }
}

struct RecordingRow2: View {
    @ObservedObject var audioPlayer: AudioPlayer2
    @State private var isEditing: Bool = false
    @State private var newName: String = ""
    var recording: Recording2
    
    var isPlayingThisRecording: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if isEditing {
                    TextField("Enter new name", text: $newName, onCommit: {
                        // Save the new name
                        recording.name = newName
                        isEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
                    .transition(.opacity)
                } else {
                    Text(recording.name)
                        .fontWeight(isPlayingThisRecording ? .bold : .regular)
                        .onTapGesture {
                            isEditing = true
                            newName = recording.name
                        }
                }
            }
            Spacer()
            if isPlayingThisRecording {
                Button {
                    audioPlayer.stopPlayback()
                } label: {
                    Image(systemName: "stop.circle.fill")
                        .imageScale(.large)
                        .font(.system(size: 30))
                        .foregroundStyle(.green, .tertiary)
                }
            } else {
                Button {
                    audioPlayer.startPlayback(recording: recording)
                } label: {
                    Image(systemName: "play.circle.fill")
                        .imageScale(.large)
                        .font(.system(size: 30))
                        .foregroundStyle(.green, .tertiary)
                }
            }
        }
    }
    
    func getDuration(of recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(recording.name)")
            return nil
        }
    }
}

//
//  Recording.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//

import Foundation

class Recording2 {
    var createdAt: Date
    var id: UUID
    var name: String
    var recordingData: Data
    
    init(createdAt: Date, id: UUID, name: String, recordingData: Data) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.recordingData = recordingData
    }
    
}
