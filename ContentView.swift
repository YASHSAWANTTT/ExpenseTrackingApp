//  ContentView.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var viewModel = ActivityViewModel(context: PersistenceController.shared.container.viewContext)
    @State private var showingAddActivity = false
    @State private var showingThresholdView = false
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Button("Filter Activities") {
                    viewModel.fetchActivities(from: startDate, to: endDate)
                }
                List {
                    ForEach(viewModel.activities, id: \.id) { activity in
                        VStack(alignment: .leading) {
                            Text(activity.descriptionText ?? "No description")
                            Text("Amount: \(activity.amount)").font(.subheadline)
                            Text("Date: \(activity.date ?? Date(), formatter: ContentView.dateFormatter)").font(.subheadline)
                            Text("Category: \(activity.category ?? "No category")").font(.subheadline)
                        }
                    }
                    .onDelete(perform: viewModel.deleteActivity)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddActivity = true }) {
                            Label("Add Activity", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Set Threshold") {
                            showingThresholdView = true
                        }
                    }
                }
                .sheet(isPresented: $showingAddActivity) {
                    AddActivityView(viewModel: viewModel)
                }
                .sheet(isPresented: $showingThresholdView) {
                    ThresholdSettingView(threshold: $viewModel.threshold)
                }
            }.padding()
            .navigationTitle("Activities")
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
