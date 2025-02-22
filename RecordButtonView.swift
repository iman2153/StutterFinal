
import SwiftUI
import Foundation

struct RecordButtonView: View {
    @Binding var isRecording: Bool
    @State var buttonSize: CGFloat = 1
    let buttonPress: () -> Void
    
    var body: some View {
        VStack{
            Button {
                buttonPress()
                isRecording.toggle()
                
            } label: {
                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
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
            isRecording ? Text("End") : Text("Start Recording")
                
                
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
