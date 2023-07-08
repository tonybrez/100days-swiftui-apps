//
//  WeSplitAppContentView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/8/23.
//

import SwiftUI

// MARK: - DAY 17-18
struct WeSplitAppContentView: View {
    /// State Properties
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool /// @FocusState property wrapper are true whenever the View is focused - should be receiving input from the user

    /// Stored Properties
    private let userCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    private let tipPercentages = [10, 15, 20, 25, 0]
    
    /// Computed Properties
    private var checkTotal: Double {
        let tipValue = checkAmount / 100 * Double(tipPercentage)
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    /// SwiftUI's TextField only lets us enter Strings. To work with other data types we have to give it a format. In this TextField, we are getting the user's Local's currency.
                    /// Locale is a massive struct that holds the user's region settings.
                    TextField("Amount", value: $checkAmount, format: userCurrency)
                        .keyboardType(.decimalPad) /// Adds a decimal keyboard type. It doesn't stop the user from copy-pasting other values, but TextFIeld will discard values out of the given format
                        .focused($amountIsFocused) /// When the user taps the TextField, amountIsFocused toggles to true.
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    /// Section has a header closure to add a View as a header
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    /// A computed property is also accepted and refreshes itself.
                    Text(checkTotal, format: userCurrency)
                        .foregroundColor(tipPercentage == 0 ? .red : .black) /// Challenge #1 of Day 24
                } header: {
                    /// Section has a header closure to add a View as a header
                    Text("Grand Total")
                }
                
                Section {
                    /// A computed property is also accepted and refreshes itself.
                    Text(totalPerPerson, format: userCurrency)
                } header: {
                    /// Section has a header closure to add a View as a header
                    Text("Amount per person")
                }
                
            }
            /// navigationTitle goes INSIDE the NavigationView and not outside like anyone would expect coming from UIKit.
            /// This is because NavigationView is capable of showing many views as the app pushes and pops other views, so the title should belong to the view enclosed to the NavigationView.
            .navigationTitle("WeSplit")
            
            /// Similar to navigationTitle, toolbar belongs to the view rather the enclosing NavigationView.
            .toolbar {
                /// Adds a ToolbarItemGroup to the keyboard belonging to this View.
                ToolbarItemGroup(placement: .keyboard) {
                    /// Spacer
                    Spacer()
                    Button("Done") {
                        /// When Done is tapped, amountIsFocused will be false.
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}
