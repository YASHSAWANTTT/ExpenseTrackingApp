
//  ThresholdSettingView.swift
//  ExpenseTrackingApp
//  Created by Yash Sawant on 4/3/24.


import SwiftUI

struct ThresholdSettingView: View {
    @Binding var threshold: Double

    var body: some View {
        Form {
            TextField("Threshold", value: $threshold, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
        }
        .navigationTitle("Threshold")
    }
}

