//  ActivitiesListView.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.


import SwiftUI

struct ActivitiesListView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.activities) { activity in
                VStack(alignment: .leading) {
                    Text(activity.descriptionText ?? "Unknown")
                        .font(.headline)
                    Text("\(activity.amount)")
                    Text(activity.category ?? "Unknown")
                }
            }
        }
        .onAppear {
            viewModel.fetchActivities()
        }
    }
}
