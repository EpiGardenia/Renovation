//
//  ItemRowView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var project: Project
    // thus we catch the "objectwillchange" in update() of EditItemView
    @ObservedObject var item: Item

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Label {
                Text(item.itemTitle)
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
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(project: Project.example, item: Item.example)
    }
}
