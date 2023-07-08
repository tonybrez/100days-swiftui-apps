//
//  UnitConverterAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/8/23.
//

import SwiftUI

// MARK: - DAY 19
struct UnitConverterAppView: View {
    @State private var inputUnit: Length = .meters
    @State private var outputUnit: Length = .kilometers
    @State private var inputCoefficient: Double = 1.0
    @FocusState private var textFieldIsFocused: Bool
    
    private var convertedResult: Double {
        let convertedInputToMeters = inputCoefficient / inputUnit.fromOneMeterConversion
        let result = convertedInputToMeters * outputUnit.fromOneMeterConversion
        return result
    }
    
    private enum Length: CaseIterable {
        case meters, kilometers, feet, yard, miles
        
        var description: String {
            switch self {
            case .meters:
                return "m"
            case .kilometers:
                return "km"
            case .feet:
                return "ft"
            case .yard:
                return "yd"
            case .miles:
                return "mi"
            }
        }
        
        var fromOneMeterConversion: Double {
            switch self {
            case .meters:
                return 1.0
            case .kilometers:
                return 0.001
            case .feet:
                return 3.28084
            case .yard:
                return 1.09361
            case .miles:
                return 0.000621371
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Length in:", selection: $inputUnit) {
                        ForEach(Self.Length.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Unit")
                }
                
                Section {
                    Picker("To:", selection: $outputUnit) {
                        ForEach(Self.Length.allCases, id: \.self) {
                            Text($0.description)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Unit")
                }
                
                Section {
                    TextField("Number", value: $inputCoefficient, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($textFieldIsFocused)
                }
                
                Section {
                    Text("Converted Result: \(convertedResult)")
                }
            }
            .navigationTitle("Unit Converter")
            
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        textFieldIsFocused = false
                    }
                }
            }
        }
    }
}
