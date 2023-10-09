//
//  iExpenseLearningPointsSecondView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 10/9/23.
//

import SwiftUI

// MARK: - DAY 36
struct iExpenseLearningPointsSecondView: View {
    // MARK: - Properties
    let name: String
    @Environment(\.dismiss) var dismiss /// @Environment is a property wrapper to access values from the environment, allowing passing data and dependencies down the view hierarchy
    @State private var numbers = [Int]()
    @AppStorage("tapCount") private var tapCount = 0 /// @AppStorage is a property wrapper short-hanededly to read UserDefaults
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Hello, \(name)!")
                
                VStack {
                    List {
                        /// ForEach items have an in-built propertu .onDelete to handle swipe to delete functionality
                        ForEach(numbers, id: \.self) {
                            Text("Row \($0) - Swipe left to delete")
                        }
                        .onDelete(perform: removeRows)
                    }
                    
                    Button("Add Number") {
                        numbers.append(tapCount)
                        tapCount += 1
                        UserDefaults.standard.set(tapCount, forKey: "Tap")
                    }
                }
                
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            .toolbar {
                EditButton()
            }
        }
        
        
    }
               
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}
