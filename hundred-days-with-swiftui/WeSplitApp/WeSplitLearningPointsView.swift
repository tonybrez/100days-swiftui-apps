//
//  WeSplitLearningPointsView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/17/23.
//

import SwiftUI

// MARK: - DAY 7
struct WeSplitLearningPointsView: View {
    /// A SwiftUI View is a struct;  immutable and therefore cannot change its values. To modify a state, we need to assign it an @State decorator. @State properties should ideally be 'private' to let developers know these aren't mean to be designed specifically for this one view.
    @State private var tapCount = 0
    @State private var name = ""
    
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"
    
    var body: some View {
        /// NavigationView allows to place a navigation bar on top of the screen and give us the ability to navigate to other screens
        NavigationView {
            Form { /// Forms are limited to 10 items. To circumvent this, declare items inside groups or sections.
                Group { /// Groups don't provide a UI different
                    Text("Hello, world! 1")
                    Text("Hello, world! 2")
                    Text("Hello, world! 3")
                    Text("Hello, world! 4")
                    Text("Hello, world! 5")
                }
                
                Section { /// Sections splits the content similar to how the iPhone's Settings app devices its features.
                    Text("Hello, world! 6")
                    Text("Hello, world! 7")
                    Text("Hello, world! 8")
                    Text("Hello, world! 9")
                    Text("Hello, world! 10")
                    Text("Hello, world! 11")
                }
            }
            .navigationTitle("We Split") /// Adds a navigation title to the Form. If this would be added to the NavigationView, the same title would be shared between all views on this navigation stack.
            .navigationBarTitleDisplayMode(.inline)
        }
        
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
        .foregroundColor(Color.white)
        .background(Color.blue)
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        
        Form {
            /// The '$' tells us that this @State variable is a two-way binding. This means that the value is read back at the same time it is modified. Not having the '$' means it's one-way binding and it'll only be read. In instances like a TextField, a Binding variable is required because the TextField by nature OWNS and NEEDS the value to be written to then be read back.
            TextField("Enter your new name", text: $name)
            Text("Your current name is: \(name)")
                .font(.subheadline)
        }
        .frame(height: 160)
        
        Form {
            /// Using ForEach is particularly useful for Picker view because it has an array of possible values and @State for the value of the selected value
            Picker("Select your student", selection: $selectedStudent) {
                /// ForEach can create a given content (ContentView) in a loop given a collection.
                /// ForEach needs an id to identify every item in the collection uniquely in case it needs to change something about it later. In this case, we are saying \.self, which means that the item itself (in this case, a String with the name of the student) is the unique identifier.
                ForEach(students, id: \.self) {
                    Text($0)
                }
            }
        }
        .frame(height: 120)
    }
}

struct WeSplitLearningPointsView_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitLearningPointsView()
    }
}

