//
//  ActionRowView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct ActionRowView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject var action: Action

    var body: some View {
        NavigationLink(destination: EditActionView(action: action)) {
            Label {
                Text(action.actionTitle)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(viewModel.color.map { Color($0) } ?? .clear )
            }
        }
        .accessibilityLabel(Text(viewModel.label))
    }

    init(renovation: Renovation, action: Action) {
        let viewModel = ViewModel(renovation: renovation, action: action)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.action = action
    }
}


struct actionRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActionRowView(renovation: Renovation.example, action: Action.example)
    }
}
