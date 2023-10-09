//
//  hundred_days_with_swiftuiApp.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/8/23.
//

import SwiftUI

@main
struct hundred_days_with_swiftuiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //WeSplitAppContentView()
            //UnitConverterAppView()
            //GuessTheFlagAppView()
            //TechnicalProjectAppView()
            //RockPaperScissorsAppView()
            //BetterRestAppView()
            //WordScrambleAppView()
            //AnimationsAppView()
            //MultiplyTablesGameAppView()
            iExpenseLearningPointsView()
        }
    }
}
