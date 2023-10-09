//
//  WordScrambleAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 7/1/23.
//

import CoreML
import SwiftUI

// MARK: - DAY 29-31
struct WordScrambleAppView: View {
    // MARK: - Properties
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack {
                Text("Score: \(score)")
                    .font(.subheadline)
                
                List {
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)

                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                }
            }
            
            
            .navigationTitle(rootWord)
            .toolbar {
                Button("Reset", action: resetGame)
            }
            .onSubmit(addNewWord)
            
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        
        .onAppear(perform: startGame)
    }
    
    // MARK: - Methods
    private func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    private func resetGame() {
        startGame()
        score = 0
        usedWords = [String]()
    }
    
    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) /// lowercase and trim the word, to make sure we don't add duplicate words with case differences
        guard answer.count > 0 else { return } /// exit if the remaining string is empty
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
            calculateScore()
        }
        newWord = ""
    }
    
    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    private func calculateScore() {
        let allCharactersAmount = (usedWords.map { $0.count }).reduce(0, +)
        score = usedWords.count * allCharactersAmount
    }
    
    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

