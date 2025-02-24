//
//  whatsnew.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/21/25.
//
import SwiftUI


struct FeatureListEntry: View {
    let icon: String
    let text: String
    let mfaFile: String?
    @State private var isPlaying: Bool = false
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 30))
            Text(text)
                .multilineTextAlignment(.center)
                .font(.system(size: 30))
                .padding()
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            if let mfaFile = mfaFile {
                Button(action: {
                    self.isPlaying.toggle()
                    Task {
                        if self.isPlaying {
                            await Sounds.playSounds(soundfile: mfaFile)
                        } else {
                            await Sounds.stop()
                        }
                    }
                }, label: {
                    Image(systemName: self.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                })
            }
        }
    }
}

struct WhatsNewView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("microphone")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text("Meet StutterKit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                FeatureListEntry(icon: "🎙️", text: "Hone your public speaking", mfaFile: nil)
                FeatureListEntry(icon: "🤖", text: "AI-powered feedback to detect:", mfaFile: nil)
                FeatureListEntry(icon: "🔄", text: "Word Repetition, like \"frog frog\"", mfaFile: "WordRep.m4a")
                FeatureListEntry(icon: "📢", text: "Sound Repetition, like \"fu fu frog\"", mfaFile: "SoundRep.m4a")
                FeatureListEntry(icon: "➡️", text: "Prolongation, like \"ffffrog\"", mfaFile: "Prolongation.m4a")
                FeatureListEntry(icon: "✨", text: "No Stutters, like \"frog\"", mfaFile: "NoStutter.m4a")
            }
            
            Button("Get Started") {
                isPresented = false
                UserDefaults.standard.set(true, forKey: "hasSeenWhatsNew")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    WhatsNewView(isPresented: .constant(true))
}
