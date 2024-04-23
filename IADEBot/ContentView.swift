//
//  ContentView.swift
//  IADEBot
//
//  Created by Ezequiel dos Santos on 28/03/2024.
//

import SwiftUI
import SwiftUISpeechToText

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer(localeIdentifier: "pt-PT")
    @State var title:String = "Start Recording"
    @State var isRecording:Bool = false
    @State var color:Color = .cyan
    var body: some View {
        VStack {
            Spacer()
            Text("\((isRecording == false) ? "":((speechRecognizer.transcript == "") ? "Speak Now": speechRecognizer.transcript))")
            Spacer()
            Button("\(title)") {
                isRecording.toggle()
                if  isRecording {
                    speechRecognizer.transcribe()
                    title = "Stop Recording"
                    color = .red
                    //TTS_IOS().speak(speechRecognizer.transcript, voice: <#T##String!#>, volume: <#T##Float#>, pitch: <#T##Float#>, rate: <#T##Float#>, utterance_id: <#T##Int32#>, interrupt: <#T##Bool#>)
                }else{
                    speechRecognizer.stopTranscribing()
                    title = "Start Recording"
                    color = .cyan
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(color)
            Spacer()
        }
    }
}

//#Preview {
//    ContentView()
//}
