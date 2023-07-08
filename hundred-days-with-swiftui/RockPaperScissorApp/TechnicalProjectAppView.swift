//
//  TechnicalProjectAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 5/20/23.
//

import SwiftUI

// MARK: - DAY 23-24
struct TechnicalProjectAppView: View {
    // SwiftUI uses struct instead of class because it has better performance due to a struct not being modifiable, as well as it dictates a cleaner design pattern where views are unmodifiable views are separated from other logic.
    
    @State private var useRedColor = false
    
    let motto1 = Text("Draco dormiens") /// View as stored propertu
    var motto2: some View { /// View as computed property
        Text("nunquam titillandus")
    }
    
    
    // Returning some View means even though we don’t know what view type is going back, the compiler does. “opaque return types”
    var body: some View {
        // In SwiftUI, there is no "background view" behind all views, and you shouldn't try to hack a way to include a backgroundView concept like UIKit has. The correct solution is to make the subviews take more space to allow it to fill the screen.
        VStack { // VStack under the hood is a TupleView that holds up to 10 views
            motto1
                .foregroundColor(.green) /// You can apply modifiers to views as stored properties when invoked
            motto2
                .foregroundColor(.blue) /// You can apply modifiers to views as computed properties when invoked
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        
        // In SwiftUI, the order of the modifiers DO matter. Under the hood, SwiftUI adds modifiers in a stack of generics.
        /// This button will look like a small red button because it will draw the red background in its default size, THEN adjust the frame.
        Button("Hello, world!") {
            print(type(of: self.body))
        }
        .background(.red)
        .frame(width: 200, height: 200)
        
        /// This button will look like the expected 200x200 red button because it adjusts the frame and then draws the red background.
        Button("Hello, world!") {
            print(type(of: self.body))
        }
        .frame(width: 200, height: 200)
        .background(.red)
        
        /// This text will have borders of all 4 colors one after the other due to having a re-adjusting padding() before every background modifier.
        //        Text("Hello, world!")
        //            .padding()
        //            .background(.red)
        //            .padding()
        //            .background(.blue)
        //            .padding()
        //            .background(.green)
        //            .padding()
        //            .background(.yellow)
        
        //customView()
        hogwartsHouses()
    }
    
    // This is not legal because the "View" protocol is not conformed; View expects a type of View, not View itself.
    //    struct CustomContentView: View {
    //        var body: View {
    //            Text("Hello World")
    //        }
    //    }
    
    // This is legal because Text is a type of View
    struct CustomTextView: View {
        var body: Text {
            Text("Hello World")
        }
    }
    
    // @ViewBuilder can create a complex view as a property
    @ViewBuilder var spells: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    
    // The @ViewBuilder decorator silently wraps multiple views in a TupleView.
    @ViewBuilder
    func customView() -> some View {
        VStack {
            VStack(spacing: 10) {
                CapsuleText(text: "First")
                    .foregroundColor(.white)
                CapsuleText(text: "Second")
                    .foregroundColor(.yellow)
            }
        }
        .background(useRedColor ? .red : .blue) /// Conditional modifier
    }
    
    @ViewBuilder
    func hogwartsHouses() -> some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle) /// Enviromental modifiers like font() overrides the modifiers that its container view defines
            Text("Hufflepuff")
                .blur(radius: 0) /// Regular modifiers like blur() will not override the modifiers that its container view defines
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.title)
        .blur(radius: 5)
    }
}

// View Composition is creating complex views separately from your Main View and invoking it later. This works similar to creating separate UIViews and then adding them into a UIViewController in UIKit
struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

// Custom Modifiers can be created by creating structs that conform to the ViewModifier protocol
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .titleStyle()
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

// To use the custom modifier, it is good practice to access through functions in an extension.
/// Tip: Often folks wonder when it’s better to add a custom view modifier versus just adding a new method to View,
/// and really it comes down to one main reason: custom view modifiers can have their own stored properties, whereas extensions to View cannot.
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}
