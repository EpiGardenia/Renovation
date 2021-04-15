//
//  RenovationHeaderView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct RenovationHeaderView: View {
    @ObservedObject var renovation: Renovation

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(renovation.renovationTitle)
                    .imageScale(.large)
                    .padding(.bottom, 10)
                ProgressView(value: renovation.completionAmount)
                    .accentColor(Color(renovation.renovationColor))

            }

            Spacer()

            NavigationLink(destination: EditRenovationView(renovation: renovation)) {
                Image(systemName: "square.and.pencil")
                EmptyView()
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)  // read all at once
    }
}

struct RenovationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        RenovationHeaderView(renovation: Renovation.example)
    }
}
