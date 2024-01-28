//
//  MoonshotLearningPointsSecondView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 1/28/24.
//

import SwiftUI

// MARK: - DAY 39
/// LazyVGrid and LaztHGrid makes it possible to display columns of data.
/// Rows per column or Columns per row can have fixed dimensions, or adaptive dimensions that adapt to different screen sizes.
struct MoonshotLearningPointsSecondView: View {
    // MARK: - Properties
    let fixedLayout = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    let adaptiveLayout = [
        GridItem(.adaptive(minimum: 80)),
    ]
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: adaptiveLayout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
        .navigationTitle("Grids")
    }
}
