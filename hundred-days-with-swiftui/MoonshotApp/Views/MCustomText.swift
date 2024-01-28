//
//  MCustomText.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 1/28/24.
//

import SwiftUI

struct MCustomText: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
    
    init(_ text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}
