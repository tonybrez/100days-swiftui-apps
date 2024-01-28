//
//  iExpenseAppView.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 11/19/23.
//

import SwiftUI

// MARK: - DAY 37-38
struct iExpenseAppView: View {
    // MARK: - Properties
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    var userPreferredCurrency: String {
        let userLocale = Locale.current
        if let currencyCode = userLocale.currency?.identifier {
            return currencyCode
        } else {
            return "USD"
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                /// In this ForEach, we don't pass anything in the id argument because ExpenseItem is conforming to the Identifiable protocol.
                Section(header: Text("Expense Items")) {
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: userPreferredCurrency))
                                .foregroundColor(getExpenseColor(for: item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .listStyle(.insetGrouped)
            
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
    
    func getExpenseColor(for amount: Double) -> Color {
        switch amount {
        case let x where x < 10.0:
            return Color.green
        case let x where x >= 10.0 && x < 100.0:
            return Color.primary
        case let x where x >= 100.0:
            return Color.red
        default:
            return Color.primary
        }
    }
}
