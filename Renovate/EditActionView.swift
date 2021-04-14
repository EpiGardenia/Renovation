//
//  EditactionView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct EditActionView: View {
    let action: Action
    @EnvironmentObject var dataController: DataController
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    init(action: Action) {
        self.action = action
        _title = State(wrappedValue: action.actionTitle)
        _detail = State(wrappedValue: action.actionDetail)
        _priority = State(wrappedValue: Int(action.priority))
        _completed = State(wrappedValue: action.completed)
    }
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Action name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle(String.localize("Mark Completed",comment: "") , isOn: $completed.onChange(update))
            }
        }
        .navigationTitle(String.localize("Edit Action", comment: ""))
        .onDisappear(perform: dataController.save)
    }

    func update() {
        action.renovation?.objectWillChange.send()
        action.title = title
        action.detail = detail
        action.priority = Int16(priority)
        action.completed = completed
    }


}




struct EditactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditActionView(action: Action.example)
    }
}
