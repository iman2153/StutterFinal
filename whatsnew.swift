//
//  whatsnew.swift
//  stutterTest3
//
//  Created by Iman Morshed on 2/21/25.
//
import SwiftUI

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
                FeatureRow(icon: "🎙️", text: "Practice rehearsing your speeches before WWDC")
                FeatureRow(icon: "🤖", text: "Get real-time feedback with our custom machine learning model")
            }
            
            
            Button("Get Started") {
                isPresented = false
                UserDefaults.standard.set(true, forKey: "hasSeenWhatsNew")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Text(icon)
            Text(text)
        }
    }
}

#Preview {
    WhatsNewView(isPresented: .constant(true))
}
