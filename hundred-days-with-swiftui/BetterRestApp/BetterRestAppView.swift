//
//  BetterRestAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 7/1/23.
//

import CoreML
import SwiftUI

// MARK: - DAY 26-28
struct BetterRestAppView: View {
    // MARK: - Properties
    private let kMinHours: Double = 4
    private let kMaxHours: Double = 12
    private let kHourStep: Double = 0.25
    private let kMinCoffeeAmount: Int = 1
    private let kMaxCoffeeAmount: Int = 20
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                    DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: kMinHours...kMaxHours, step: kHourStep)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("Coffee cups", selection: $coffeeAmount) {
                        ForEach(kMinCoffeeAmount...kMaxCoffeeAmount, id: \.self) { amount in
                            Text("\(amount) cup\(amount != 1 ? "s" : "")")
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Methods
    private func calculateBedtime() {
        do {
            /// An ML prediction can fail either in loading the model or doing the prediction, like when providing invalid values. Because of this, the prediction has to be done inside a do/catch block.
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config) /// When adding a .mlmodel file, a Swift class with the same name will be auto-generated. It's not visible; it's generated as part of the build process
            
            /// Calendar saves date/time values as independent Double values for convenience. We should try to use those instead
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            /// prediction() arguments correlate to the ones provided as Features properties in CreateML to do the prediction upon the Target properties.
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
  
            /// Using .formatted is preferred to manually showing date/times using Strings
            showAlert(title: "Your ideal bedtime is…", message: sleepTime.formatted(date: .omitted, time: .shortened))
        } catch {
            showAlert(title: "Error",
                      message: "Sorry, there was a problem calculating your bedtime.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

