//
//  AudioPlayer2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  AudioPlayer2.swift
//  SpeechKit
//
//  Created by Iman Morshed on 2/17/25.
//


//
//  player2.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer2: NSObject, ObservableObject, @preconcurrency AVAudioPlayerDelegate {

    @Published var currentlyPlaying: Recording2?
    @Published var isPlaying = false
    
    var audioPlayer: AVAudioPlayer?
    
    func startPlayback(recording: Recording2) {
        let recordingData = recording.recordingData
        if true {
            let playbackSession = AVAudioSession.sharedInstance()
            
            
            do {
                try playbackSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.spokenAudio)
                try playbackSession.setActive(true)
                print("Start Recording - Playback session setted")
            } catch {
                print("Play Recording - Failed to set up playback session")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(data: recordingData)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                isPlaying = true
                print("Play Recording - Playing")
                withAnimation(.spring()) {
                    currentlyPlaying = recording
                }
            } catch {
                print("Play Recording - Playback failed: - \(error)")
                withAnimation {
                    currentlyPlaying = nil
                }
            }
        } else {
            withAnimation {
                currentlyPlaying = nil
            }
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        print("Play Recording - Paused")
    }
    
    func resumePlayback() {
        audioPlayer?.play()
        isPlaying = true
        print("Play Recording - Resumed")
    }
    
    func stopPlayback() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            isPlaying = false
            print("Play Recording - Stopped")
            withAnimation(.spring()) {
                self.currentlyPlaying = nil
            }
        } else {
            print("Play Recording - Failed to Stop playing - Coz the recording is not playing")
        }
    }
    
    @MainActor func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            print("Play Recording - Recoring finished playing")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                        self.currentlyPlaying = nil
                    
                }
            }
        }
    }
    
}
