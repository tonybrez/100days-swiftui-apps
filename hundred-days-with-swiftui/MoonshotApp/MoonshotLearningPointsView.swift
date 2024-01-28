//
//  MoonshotLearningPointsView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 1/28/24.
//

import SwiftUI

// MARK: - DAY 39
struct MoonshotLearningPointsView: View {
    // MARK: - Body
    var body: some View {
        /// NavigationStack displays a navigation bar at the top of the views, but also allows for pushing views into the stack.
        NavigationStack {
            ScrollView {
                /// LazyVStack and LazyHStack loads views as they need. This helps with performance.
                LazyVStack(spacing: 10) {
                    Image("Example")
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .background(Color.red)
                    
                    Spacer()
                    
                    /// containerRelativeFrame allows for adaptive image resizing depending on the available space
                    Image("Example")
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.8
                        }
                        .background(Color.blue)
                    
                    Spacer()
                    
                    /// Pushes a new view into the stack
                    NavigationLink("Tap me to learn about Grids") {
                        MoonshotLearningPointsSecondView()
                    }
                    
                    ForEach(0..<100) {
                        MCustomText("Item \($0 + 1)")
                            .font(.title)
                            .foregroundColor(Color.green)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.primary)
        }
    }
}
