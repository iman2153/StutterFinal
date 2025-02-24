import AVKit
import AVFoundation

actor Sounds {
    private static let shared = Sounds()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                          mode: .default,
                                                          options: [.defaultToSpeaker])
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    static func playSounds(soundfile: String) async {
        await shared.play(soundfile: soundfile)
    }
    
    static func stop() async {
        await shared.stopPlaying()
    }
    
    private func play(soundfile: String) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord,
                                  options: .defaultToSpeaker)
            
            guard let path = Bundle.main.path(forResource: soundfile, ofType: nil) else {
                print("Could not find sound file: \(soundfile)")
                return
            }
            
            let url = URL(fileURLWithPath: path)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Successfully playing sound: \(soundfile)")
            
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
    }
}
