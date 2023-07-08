//
//  GuessTheFlagAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/27/23.
//

import SwiftUI

// MARK: - DAY 21-22
class GuessTheFlagViewModel: ObservableObject {
    @Published var flagImages = [FlagImage]()
    @Published var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    @Published var showingScore = false
    @Published var scoreTitle = ""
    @Published var correctAnswer = Int.random(in: 0...2)
    @Published var userScore = 0
    
    init() {
        askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagImages = [FlagImage(country: countries[0]), FlagImage(country: countries[1]), FlagImage(country: countries[2])]
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        for (i, _) in flagImages.enumerated() {
            if i == number {
                flagImages[i].activateRotation()
            } else {
                flagImages[i].activateOpacity()
            }
        }
        
        showingScore = true
    }
}

struct GuessTheFlagAppView: View {
    // MARK: - Properties
    @ObservedObject var viewModel = GuessTheFlagViewModel()
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 16) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(viewModel.countries[viewModel.correctAnswer])
                            .countryLargeTitle()
                        
                        ForEach(0..<3) { number in
                            Button {
                                viewModel.flagTapped(number)
                            } label: {
                                viewModel.flagImages[number]
                            }
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(viewModel.userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        
        .alert(viewModel.scoreTitle, isPresented: $viewModel.showingScore) {
            Button("Continue", action: viewModel.askQuestion)
        } message: {
            Text("Your score is \(viewModel.userScore)")
        }
    }
}

/// Challenge #2 of Day 24
struct FlagImage: View {
    var country: String
    var angle = 0.0
    var opacity = 1.0
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .opacity(opacity)
            .rotationEffect(.degrees(angle))
            .animation(.easeIn, value: angle)
    }
    
    public mutating func activateRotation() {
        withAnimation {
            angle += 360
        }
    }
    
    public mutating func activateOpacity() {
        withAnimation {
            opacity = 0.50
        }
    }
}

/// Challenge #3 of Day 24
struct CountryTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.semibold))
    }
}
extension View {
    func countryLargeTitle() -> some View {
        modifier(CountryTitle())
    }
}
