//
//  RecorderBar2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  RecorderBar2.swift
//  SpeechKit
//
//  Created by Iman Morshed on 2/17/25.
//


//
//  rb2.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//

import Foundation
//
//  RecorderBar.swift
//  VoiceRecTest
//
//  Created by Umayanga Alahakoon on 2022-07-22.
//

import SwiftUI

struct RecorderBar2: View {
    @ObservedObject var audioRecorder = AudioRecorder2()
    @ObservedObject var audioPlayer: AudioPlayer2
    
    @State var buttonSize: CGFloat = 1
    
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
        .repeatForever()
    }
    
    var body: some View {
        VStack {
                        
            recordButton
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var recordButton: some View {
        Button {
            if audioRecorder.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipped()
                .foregroundColor(.green)
                .scaleEffect(buttonSize)
                .onChange(of: audioRecorder.isRecording) { isRecording in
                    if isRecording {
                        withAnimation(repeatingAnimation) { buttonSize = 1.1 }
                    } else {
                        withAnimation { buttonSize = 1 }
                    }
                }
        }
    }
    
    func startRecording() {
        if audioPlayer.audioPlayer?.isPlaying ?? false {
            // stop any playing recordings
            audioPlayer.stopPlayback()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Start Recording
                audioRecorder.startRecording()
            }
        } else {
            // Start Recording
            audioRecorder.startRecording()
        }
    }
    
    func stopRecording() {
        // Stop Recording
        audioRecorder.stopRecording()
    }
    
}

