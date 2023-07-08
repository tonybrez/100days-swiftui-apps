//
//  RockPaperScissorsAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 5/22/23.
//

import SwiftUI

// MARK: - DAY 25
struct RockPaperScissorsAppView: View {
    // MARK: - Properties
    let kNumberOfRounds = 10
    
    @State private var round = 1
    
    @State private var cpuScore = 0
    @State private var playerScore = 0
    
    @State private var conditionIsWin = Bool.random()
    @State private var cpuSelectedOption = RPSOption.random()
    @State private var playerSelectedOption = RPSOption.random()
    
    @State private var gameEnded = false
    @State private var showingAlert = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                VStack(spacing: 8) {
                    Text("ROCK PAPER SCISSORS")
                        .foregroundStyle(.primary)
                        .font(Font(CTFont(.alertHeader, size: 28)))
                        .padding(.vertical, 16)
                    
                    Text("ROUND \(round)")
                        .foregroundStyle(.primary)
                        .font(.headline.bold())
                    
                    Text("\(conditionIsWin ? "WIN" : "LOSE") against the CPU to score the point")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack {
                    // Your Score and your selection image
                    // CPU selection and score
                }
                
                Spacer()
                
                VStack {
                    Text("What will you play?")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(RPSOption.allCases) { option in
                            OptionButton(option: option) {
                                rpsOptionTapped(option)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
            }
        }
        
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Continue", action: prepareNextRound)
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Methods
    func rpsOptionTapped(_ option: RPSOption) {
        playerSelectedOption = option
        
        print("CPU SELECTED: \(cpuSelectedOption)")
        print("PLAYER SELECTED: \(playerSelectedOption)")
        
        if playerSelectedOption == cpuSelectedOption {
            rebuildRound()
            return
        }
        
        if conditionIsWin {
            let playerDidWin = (playerSelectedOption == .paper && cpuSelectedOption == .rock) ||
            (playerSelectedOption == .rock && cpuSelectedOption == .scissors) ||
            (playerSelectedOption == .scissors && cpuSelectedOption == .paper)
            calculateGame(playerDidWin: playerDidWin)
        } else {
            let playerDidWin = (playerSelectedOption == .paper && cpuSelectedOption == .scissors) ||
            (playerSelectedOption == .rock && cpuSelectedOption == .paper) ||
            (playerSelectedOption == .scissors && cpuSelectedOption == .rock)
            calculateGame(playerDidWin: playerDidWin)
        }
        
        //        if number == correctAnswer {
        //            scoreTitle = "Correct!"
        //            userScore += 1
        //        } else {
        //            scoreTitle = "Wrong! That's the flag of \(countries[correctAnswer])"
        //        }
        //
        //        showingScore = true
    }
    
    private func calculateGame(playerDidWin: Bool) {
        if playerDidWin {
            alertTitle = "Round \(round)"
            alertMessage = "Player Wins!"
            playerScore += 1
        } else {
            alertTitle = "Round \(round)"
            alertMessage = "Player Loses..."
            cpuScore += 1
        }
        
        showingAlert = true
    }
    
    private func resetGame() {
        round = 0
        cpuScore = 0
        playerScore = 0
        
        prepareNextRound()
    }
    
    private func prepareNextRound() {
        round += 1
        cpuSelectedOption = RPSOption.random()
        conditionIsWin = Bool.random()
    }
    
    private func rebuildRound() {
        cpuSelectedOption = RPSOption.random()
        conditionIsWin = Bool.random()
    }
}

enum RPSOption: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case rock, paper, scissors
    
    var associatedImageName: String {
        return"\(self)-hand"
    }
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> RPSOption {
        return RPSOption.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> RPSOption {
        var g = SystemRandomNumberGenerator()
        return RPSOption.random(using: &g)
    }
}

struct OptionButton: View {
    var option: RPSOption
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(option.associatedImageName)
                    .renderingMode(.original)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                Text(option.rawValue)
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
            }
        }
    }
}

//struct CountryTitle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.largeTitle.weight(.semibold))
//    }
//}
//extension View {
//    func countryLargeTitle() -> some View {
//        modifier(CountryTitle())
//    }
//}
