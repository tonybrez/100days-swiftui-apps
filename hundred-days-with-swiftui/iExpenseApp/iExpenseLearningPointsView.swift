//
//  iExpenseLearningPointsView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 10/9/23.
//

import SwiftUI

// MARK: - DAY 36
///  Contrary to structs which exist which get recreated when mutated. Classes exists as one instance in memory.
///  This means that in SwiftUI, we have to set up classes to be Observable if we want the SwiftUI View to refresh when changes happen.
///  To achieve this, we conform the class to ObservableObject, add an @Published decorator to the properties we want to observe, and instantiate it with an @StateObject decorator.
class User: ObservableObject, Codable {
    @Published var firstName: String
    @Published var lastName: String
    
    private enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
    }
    
    init(firstName: String = "John", lastName: String = "Doe") {
        self.firstName = firstName
        self.lastName = lastName
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}

struct iExpenseLearningPointsView: View {
    // MARK: - Properties
    @StateObject private var user = User()
    @State private var showingSheet = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
        
        Button("Save User") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
        
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            iExpenseLearningPointsSecondView(name: user.firstName)
        }
    }
}
