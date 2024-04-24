//
//  ContentViewModel.swift
//  IADEBot
//
//  Created by Ezequiel dos Santos on 23/04/2024.
//

import Foundation
import SwiftUISpeechToText
import SwiftUI
import Speech

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var displayText: String = "Toque o botão para começar a ouvir."
    @Published var text: String = "Boa noite! Seja bem vindo ao IADE!"
    @Published var isListening: Bool = false
    @Published var listenButtonTitle: String = "Iniciar"
    @Published var listenButtonColor: Color = .blue
    
    let speechSynthesizer: SpeechSynthesizerProviding
    let speechRecognizer: SpeechRecognizer
    private var questionsAndAnswers: [QuestionAndAnswer] = []
    
    init(speechSynthesizer: SpeechSynthesizerProviding, speechRecognizer: SpeechRecognizer) {
        self.speechSynthesizer = speechSynthesizer
        self.speechRecognizer = speechRecognizer
        loadQuestions()
    }
    
    /// Toggles the listening state of the speech recognizer.
    func toggleListening() {
        isListening.toggle()
        if isListening {
            startListening()
        } else {
            stopListening()
        }
    }
    
    private func startListening() {
        speechRecognizer.transcribe()
        listenButtonTitle = "Terminar"
        listenButtonColor = .red
    }
    
    private func stopListening() {
        speechRecognizer.stopTranscribing()
        listenButtonTitle = "Iniciar"
        listenButtonColor = .blue
        processTranscript()
    }
    
    /// Processes the transcript once speech recognition is stopped.
    private func processTranscript() {
        let cleanedTranscript = speechRecognizer.transcript.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        displayText = answer(for: cleanedTranscript) ?? "Desculpa, não consegui entender."
        speechSynthesizer.speakText(displayText)
    }
    
    /// Loads questions and answers from a JSON file.
    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let loadedData = try? JSONDecoder().decode(Questions.self, from: data) {
            questionsAndAnswers = loadedData.questions
        }
    }
    
    /// Finds an answer by matching input with predefined questions.
    private func answer(for input: String) -> String? {
        let normalizedInputWords = input.lowercased().split(separator: " ").map(String.init)
        for qa in questionsAndAnswers {
            let normalizedQuestionWords = qa.question.lowercased().split(separator: " ").map(String.init)
            let commonWords = normalizedQuestionWords.filter(normalizedInputWords.contains)
            let matchThreshold = Double(normalizedInputWords.count) * 0.5 // 50% of words must match
            if Double(commonWords.count) >= matchThreshold {
                return qa.answer
            }
        }
        return nil
    }
    
    struct Questions: Codable {
        let questions: [QuestionAndAnswer]
    }
    
    struct QuestionAndAnswer: Codable {
        let question: String
        let answer: String
    }
}

extension SpeechRecognizer {
    
    public enum LocaleIdentifier: String {
        case portugal = "pt-PT"
        case brazil = "pt-BR"
        case unitedStates = "en-US"
        case unitedKingdom = "en-GB"

        public var locale: Locale {
            return Locale(identifier: self.rawValue)
        }
    }
}


extension ContentViewModel {
    func updateQuestions(with data: Data?) {
        guard let data = data else { return }
        do {
            questionsAndAnswers = try JSONDecoder().decode(Questions.self, from: data).questions
            displayText = "Questions updated successfully."
        } catch {
            displayText = "Failed to load questions: \(error.localizedDescription)"
        }
    }
}
