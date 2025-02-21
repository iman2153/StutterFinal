//
//  RecordButtonView.swift
//  StutterAI
//
//  Created by Ben K on 10/5/21.
//

import SwiftUI
import Foundation

struct RecordButtonView: View {
    @Binding var isRecording: Bool
    @State var buttonSize: CGFloat = 1
    let buttonPress: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            
            ZStack {
               Circle()
                    .stroke(Color.white, lineWidth: geo.size.height * (height * 0.0009))
                
                Button {
                    buttonPress()
                    isRecording.toggle()
                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: height * 0.85, height: height * 0.85)
                        .clipped()
                        .foregroundColor(.green)
                        .scaleEffect(buttonSize)
                        .onChange(of: isRecording) { isRecording in
                            if isRecording {
                                withAnimation(repeatingAnimation) { buttonSize = 1.1 }
                            } else {
                                withAnimation { buttonSize = 1 }
                            }
                        }
                }
            }
        }
    }
    var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
        .repeatForever()
    }
}

struct RecordButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordButtonView(isRecording: .constant(false)) {}.preferredColorScheme(.dark)
            .frame(width: 65, height: 65)
    }
}
