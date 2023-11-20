//
//  Expenses.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 11/19/23.
//

import Foundation
import Observation

// MARK: - DAY 36
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

/// With the Identifiable protocol, we are required to conform to a property called "id", and we are using UUID() to create a unique ID.
/// This is a clean way to work with items in a table/list.
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
