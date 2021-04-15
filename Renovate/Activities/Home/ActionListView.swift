//
//  ActionListView.swift
//  Renovate
//
//  Created by T  on 2021-04-15.
//

import SwiftUI

struct ActionListView: View {
    let title: LocalizedStringKey
    let actions: FetchedResults<Action>.SubSequence
    var body: some View {
        if actions.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(actions) { action in
                NavigationLink(destination: EditActionView(action: action)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(action.renovation?.renovationColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        VStack(alignment: .leading) {
                            Text(action.actionTitle)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if action.actionDetail.isEmpty == false {
                                Text(action.actionDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}
