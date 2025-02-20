//
//  PlayerBar2.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  PlayerBar2.swift
//  SpeechKit
//
//  Created by Iman Morshed on 2/17/25.
//
import Foundation

import SwiftUI

struct PlayerBar2: View {
    @ObservedObject var audioPlayer: AudioPlayer2
    @State var sliderValue: Double = 0.0
    @State private var isDragging = false
    
    // Add time formatter
    private let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    // Computed elapsed time
    private var elapsedTime: String {
        timeFormatter.string(from: sliderValue) ?? "0:00"
    }
    
    // Computed remaining time
    private var remainingTime: String {
        guard let player = audioPlayer.audioPlayer else { return "0:00" }
        let remaining = player.duration - sliderValue
        return "-" + (timeFormatter.string(from: remaining) ?? "0:00")
    }
    
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common) // Increased update frequency
        .autoconnect()
    
    var body: some View {
        if let player = audioPlayer.audioPlayer, let currentlyPlaying = audioPlayer.currentlyPlaying {
            VStack {
                Slider(value: $sliderValue, in: 0...player.duration) { dragging in
                    isDragging = dragging
                    if !dragging {
                        player.currentTime = sliderValue
                    }
                }
                .tint(.primary)
                
                // Updated time displays
                HStack {
                    Text(elapsedTime)
                    Spacer()
                    Text(remainingTime)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                HStack(spacing: 15) {
                    // Play/Pause Button
                    Button {
                        if audioPlayer.isPlaying {
                            // Pause
                            audioPlayer.pausePlayback()
                        } else {
                            // Play
                            audioPlayer.resumePlayback()
                        }
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .imageScale(.large)
                    }

                    Text(currentlyPlaying.name)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Spacer()

                    Button {
                        audioPlayer.stopPlayback()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                    }
                    
                }
                .padding(.top, 10)
            }
            .padding()
            .foregroundColor(.primary)
            .onAppear {
                sliderValue = 0
            }
            .onReceive(timer) { _ in
                            guard !isDragging else { return }
                            sliderValue = player.currentTime
                        }
            .transition(.scale(scale: 0, anchor: .bottom))
            Divider()
        }
    }
}
