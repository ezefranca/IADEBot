//
//  ContentView.swift
//  IADEBot
//
//  Created by Ezequiel dos Santos on 28/03/2024.
//

import SwiftUI
import SwiftUISpeechToText
import Speech

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel(
        speechSynthesizer: SpeechSynthesizer(),
        speechRecognizer: SpeechRecognizer(localeIdentifier: SpeechRecognizer.LocaleIdentifier.portugal.locale.identifier)
    )
    
    @State private var showingDocumentPicker = false
    @State private var documentData: Data?
    
    var body: some View {
            VStack {
                Text(viewModel.speechRecognizer.transcript)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Spacer()
                
                Button(viewModel.listenButtonTitle) {
                    viewModel.toggleListening()
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.listenButtonColor)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button("Open JSON File") {
                               showingDocumentPicker = true
                           }
                           .padding()
                           .foregroundColor(.white)
                           .background(Color.blue)
                           .cornerRadius(8)

                           Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(documentData: $documentData) {
                    viewModel.updateQuestions(with: documentData)
                }
            }
        }
}


//#Preview {
//    ContentView()
//}
