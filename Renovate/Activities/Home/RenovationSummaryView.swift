//
//  RenovationSummaryView.swift
//  Renovate
//
//  Created by T  on 2021-04-15.
//

import SwiftUI

struct RenovationSummaryView: View {
    @ObservedObject var renovation: Renovation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(renovation.renovationActions.count) Actions")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(renovation.renovationTitle)
                .font(.title2)

            ProgressView(value: renovation.completionAmount)
                .accentColor(Color(renovation.renovationColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        // by using .combine, it reads according to default order
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(renovation.label)
    }
}

struct RenovationSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        RenovationSummaryView(renovation: Renovation.example)
    }
}
