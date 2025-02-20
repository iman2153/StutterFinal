//
//  Probability.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/20/25.
//


//
//  Probability.swift
//  SpeechKit
//
//  Created by Iman Morshed on 2/17/25.
//


//
//  Manager.swift
//  VoiceRecTest
//
//  Created by Iman Morshed on 2/22/24.
//

import Foundation
import Combine

struct Probability {
    let dict: [String: Double] // Fix: Replace '->' with ':' to define the correct dictionary type.
    let predicted : String
    init(dict: [String : Double], predicted: String) {
        self.dict = dict
        self.predicted = predicted
    }
}
class Manager {
    @MainActor static let shared = Manager()
    private init() {}
    var recordStream = PassthroughSubject<Recording2,Never>()
    var actionStream = PassthroughSubject<Probability, Never>()
    
}
