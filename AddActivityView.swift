//  AddActivityView.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.


import SwiftUI

struct AddActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ActivityViewModel

    @State private var descriptionText = ""
    @State private var amount: Double = 0
    @State private var date = Date()
    @State private var category = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Description", text: $descriptionText)
                TextField("Amount", value: $amount, formatter: NumberFormatter.decimal)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Category", text: $category)

                Button("Save") {
                    viewModel.addActivity(description: descriptionText, amount: amount, date: date, category: category)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Activity")
            .toolbar {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

extension NumberFormatter {
    static let decimal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}


