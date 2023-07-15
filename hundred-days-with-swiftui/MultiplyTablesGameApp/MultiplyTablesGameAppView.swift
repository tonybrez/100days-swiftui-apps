//
//  MultiplyTablesGameAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 7/15/23.
//

import SwiftUI

// MARK: - DAY 35
struct MultiplyTablesGameAppView: View {
    // MARK: - Properties
    struct Config {
        /// Multiplying table
        static let kMinMultiplyTable = 2
        static let kMaxMultiplyTable = 12
        static let kStepMultiplyTable = 1
        
        /// Multiplying range
        static let kMinMultiplyRange = 2
        static let kMaxMultiplyRange = 20
        static let kStepMultiplyRange = 1
        
        /// Questions
        static let kMinQuestionsAmount = 5
        static let kMaxQuestionAmount = 20
        static let kStepQuestionsAmount = 5
    }
    
    @State private var tableNumber: Int = 2
    @State private var multiplyRange: Int = 2
    @State private var questionAmount: Int = 10
    
    @State private var isGameRunning = false
    @State private var score = 0
    @State private var currentQuestion = 0
    @State private var currentFactor1 = 0
    @State private var currentFactor2 = 0
    @State private var currentRealResult = 0
    @State private var currentInputResult = "0"
    @FocusState private var isFocusedCurrentInputResult: Bool
    
    @State private var isDisplayingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertType = AlertType.none
    
    enum AlertType {
        case resetGame, gameEnded, none
    }
    
    /// UIProperties
    struct UIConfig {
        static let darkColor = Color(uiColor: UIColor(red: 25/255, green: 27/255, blue: 31/255, alpha: 1.0))
        static let actionColor = Color(uiColor: UIColor(red: 47/255, green: 102/255, blue: 246/255, alpha: 1.0))
    }
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack {
                /// Stats View
                HStack(alignment: .center, spacing: 8) {
                    VStack {
                        Text("Multiplying")
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                        Text("\(tableNumber)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                    }
                    
                    VStack {
                        Text("Range")
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                        Text("2 - \(multiplyRange)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                    }
                    
                    VStack {
                        Text("Questions")
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                        Text("\(questionAmount)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                    }
                }
                
                Spacer()
                
                /// Game View
                VStack {
                    if isGameRunning {
                        HStack {
                            Text("Question: \(currentQuestion)/\(questionAmount)")
                            Text("|")
                            Text("Score: \(score)")
                        }
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("\(currentFactor1) x \(currentFactor2) =").bold()
                                .font(.title)
                                .foregroundColor(UIConfig.darkColor)
                            
                            TextField("Result", text: $currentInputResult).bold()
                                .font(.title)
                                .frame(width: 120)
                                .foregroundColor(.white)
                                .background(UIConfig.darkColor)
                                .cornerRadius(8)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.numberPad)
                                .focused($isFocusedCurrentInputResult)
                            Spacer()
                        }
                        .padding()
                        
                    } else {
                        Text("Tap 'Start Challenge!' to begin")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(UIConfig.darkColor)
                    }
                }
                
                
                Spacer()
                
                /// Controls View
                VStack(alignment: .center) {
                    Stepper(value: $tableNumber, in: Config.kMinMultiplyTable...Config.kMaxMultiplyTable, step: Config.kStepMultiplyTable) {
                        Text("Multiplying Table")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                    Stepper(value: $multiplyRange, in: Config.kMinMultiplyRange...Config.kMaxMultiplyRange, step: Config.kStepMultiplyRange) {
                        Text("Multiplication Range")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                    Stepper(value: $questionAmount, in: Config.kMinQuestionsAmount...Config.kMaxQuestionAmount, step: Config.kStepQuestionsAmount) {
                        Text("Questions Amount")
                            .font(.body)
                            .foregroundColor(Color.white)
                    }
                    
                    Button {
                        startChallenge()
                    } label: {
                        Text("Start Challenge!")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .background(UIConfig.actionColor)
                    .cornerRadius(8.0)
                }
                .padding()
                .disabled(isGameRunning)
                .opacity(isGameRunning ? 0.25 : 1.0)
                
                /// Navigation UI
                .navigationTitle("Multiply Challenge")
                .background(UIConfig.darkColor)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            Button("Dismiss") {
                                isFocusedCurrentInputResult = false
                            }
                            Spacer()
                            Button("Submit") {
                                verifyInput()
                            }
                        }
                    }
                }
                .toolbar {
                    Button("Stop Game") {
                        showAlert(title: "End Game", message: "Are you sure you want to end the game? Your progress will be lost.", type: .resetGame)
                    }
                }
                .alert(alertTitle, isPresented: $isDisplayingAlert) {
                    switch alertType {
                    case .resetGame:
                        Button("YES") {
                            resetState()
                        }
                        Button("NO") {}
                    case .gameEnded:
                        Button("OK") {
                            resetState()
                        }
                    case .none:
                        Button("OK") {}
                    }
                    
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    // MARK: - Methods
    private func startChallenge() {
        isGameRunning = true
        currentFactor1 = tableNumber
        tryGenerateNextQuestion()
    }
    
    private func verifyInput() {
        if Int(currentInputResult) == currentRealResult {
            score += 1
        }
        
        tryGenerateNextQuestion()
    }
    
    private func tryGenerateNextQuestion () {
        currentInputResult = ""
        if currentQuestion < questionAmount {
            currentQuestion += 1
            currentFactor2 = Int.random(in: 2...multiplyRange)
            currentRealResult = currentFactor1 * currentFactor2
        } else {
            endChallenge()
        }
    }
    
    private func endChallenge() {
        isFocusedCurrentInputResult = false
        showAlert(title: "Game Results", message: "Game Over! Your final score was \(score) out of \(questionAmount) questions", type: .gameEnded)
    }
    
    private func resetState() {
        isGameRunning = false
        score = 0
        currentQuestion = 0
    }
    
    private func showAlert(title: String, message: String, type: AlertType) {
        alertType = type
        alertTitle = title
        alertMessage = message
        isDisplayingAlert = true
    }
}
