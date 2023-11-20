//
//  iExpenseAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 11/19/23.
//

import SwiftUI

// MARK: - DAY 37
struct iExpenseAppView: View {
    // MARK: - Properties
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                /// In this ForEach, we don't pass anything in the id argument because ExpenseItem is conforming to the Identifiable protocol.
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenses: expenses)
            }
        }
    }
    
    // MARK: - Methods
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}
