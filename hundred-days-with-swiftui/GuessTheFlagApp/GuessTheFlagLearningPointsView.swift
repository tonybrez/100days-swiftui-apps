//
//  GuessTheFlagAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 4/27/23.
//

import SwiftUI

// MARK: - DAY 20
struct GuessTheFlagLearningPointsView: View {
    @State private var showingAlert = false
    
    func executeDelete() {
        print("Now deleting…")
    }
    
    var body: some View {
        Group {
            /// VStack is a vertical stack of views.
            VStack {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            /// HStack is a vertical stack of views.
            HStack {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            /// VStack can have spacing and/or alignment for horizontal constraining
            VStack(spacing: 20) {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            VStack(alignment: .leading) {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            /// HStack can have spacing and/or alignment for vertical constraining
            HStack(spacing: 20) {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            HStack(alignment: .bottom) {
                Text("Hello, world!")
                Text("This is inside a stack")
            }

            /// ZStack makes arrangement by depth - it makes views that overlap. ZStack doesn’t have the concept of spacing because the views overlap, but it does have alignment.
            ZStack(alignment: .center) {
                Text("Hello, world!")
                Text("This is inside a stack")
            }
            .background(.red) /// .background assigns background color to the CONTENT of the stack

            ZStack(alignment: .center) {
                Color.red /// Assigning Color view inside the stack applies to the whole view
                Text("Hello, world!")
                Text("This is inside a stack")
            }
            .ignoresSafeArea() /// The view will ignore safe area

            /// Spacers are dynamic views that automatically push the contents of Stacks, taking up all the remaining space.
            VStack {
                Color(red: 1, green: 0.8, blue: 0)
                    .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 200) /// Color as any View, will have width, height, minWidth, minHeight, etc. properties
                Spacer()
                Text("First") /// Applying foregroundColor, padding and background to Text
                    .foregroundColor(.secondary)
                    .padding(50)
                    .background(.ultraThinMaterial)
                Text("Second")
                Text("Third")
                Spacer()
                Spacer()
            }

            VStack {
                /// LinearGradiant
                LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: .white, location: 0.45),
                    Gradient.Stop(color: .black, location: 0.55),
                ]), startPoint: .top, endPoint: .bottom)

                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .white, location: 0.45),
                    .init(color: .black, location: 0.55),
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)

                /// RadialGradient
                RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)

                /// Angular Gradient
                AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
            }
        }
        
        Group {
            VStack(spacing: 40) {
                /// Button with title, role and action.
                Button("Delete selection", role: .destructive, action: executeDelete)

                /// Different Button styles.
                Button("Button 1") { }
                    .buttonStyle(.bordered)
                Button("Button 2", role: .destructive) { }
                    .buttonStyle(.bordered)
                Button("Button 3") { }
                    .buttonStyle(.borderedProminent)
                Button("Button 4", role: .destructive) { }
                    .buttonStyle(.borderedProminent)

                /// Button with Text view as its label
                Button {
                    print("Button was tapped")
                } label: {
                    Text("Tap me!")
                        .padding()
                        .foregroundColor(.white)
                        .background(.red)
                }

                /// Button with Image view as its label
                Button {
                    print("Edit button was tapped")
                } label: {
                    Image(systemName: "pencil")
                }

                /// Button with Label view  as its label
                Button {
                    print("Edit button was tapped")
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                
                /// NOTE: If you find that your images have become filled in with a color, for example showing as solid blue rather than your actual picture, this is probably SwiftUI coloring them to show that they are tappable. To fix the problem, use the renderingMode(.original) modifier to force SwiftUI to show the original image rather than the recolored version.
            }
        }
        
        Group {
            VStack {
                /// The button will trigger the showingAlert attribute to be true.
                Button("Show Alert") {
                    showingAlert = true
                }
                
                /// It doesn't matter where the .alert is placed. Only that it'll show up when its isPresented attribute is true.
                .alert("Important message", isPresented: $showingAlert) {
                    Button("Delete", role: .destructive) { }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Please read this.")
                }
            }
        }
        
    }
}

struct GuessTheFlagLearningPointsView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheFlagLearningPointsView()
    }
}
