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
            Text("What's New")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                FeatureRow(icon: "star.fill", text: "Exciting new feature 1")
                FeatureRow(icon: "bolt.fill", text: "Performance improvements")
                FeatureRow(icon: "paintbrush.fill", text: "Fresh new design")
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
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
        }
    }
}
