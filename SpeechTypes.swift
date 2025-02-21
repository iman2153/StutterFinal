//
//  SpeechTypes.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//
import Foundation

enum AudioCharacteristic: String, CaseIterable {
    case block = "Block"
    case difficultToUnderstand = "DifficultToUnderstand"
    case interjection = "Interjection"
    case music = "Music"
    case naturalPause = "NaturalPause"
    case noSpeech = "NoSpeech"
    case noStutteredWords = "NoStutteredWords"
    case poorAudioQuality = "PoorAudioQuality"
    case prolongation = "Prolongation"
    case soundRepetition = "SoundRepetition"
    case unsure = "Unsure"
    case wordRepetition = "WordRepetition"
}
