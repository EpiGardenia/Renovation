//
//  ActionRowView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct ActionRowView: View {
    @ObservedObject var renovation: Renovation
    // thus we catch the "objectwillchange" in update() of EditActionView
    @ObservedObject var action: Action

    var body: some View {
        NavigationLink(destination: EditActionView(action: action)) {
            Label {
                Text(action.actionTitle)
            } icon: {
                icon
            }
        }
    }

    /*
     computed properties conventionally have a constant complexity, or O(1) in Big O notation, meaning that they always take the same amount of time to run regardless of input or program state.
     p.s. func icon() -> some View works too.
     */
    var icon: some View {
        if action.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(renovation.renovationColor))
        } else if action.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(renovation.renovationColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
}

struct actionRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActionRowView(renovation: Renovation.example, action: Action.example)
    }
}
