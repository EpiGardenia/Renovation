//
//  RenovationsView.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//
/*
 Extra note:
 ForEach(renovation.renovationactions, content: ActionRowView.init)
 means:
 for each action, create a new ActionRowView and pass the action in as the only parameter to the initializer

 thus can be shorthand of

 ForEach(renovation.renovationactions) { action in
 actionRowView(action: action)
 }

 */


import SwiftUI

struct RenovationsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    init(dataController: DataController, showClosedRenovations: Bool) {
        let viewModel = ViewModel(dataController: dataController,
                                  showClosedRenovations: showClosedRenovations)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var renovationList: some View {
        List {
            ForEach(viewModel.renovations) { renovation in
                Section(header: RenovationHeaderView(renovation: renovation)) {
                    ForEach(renovation.renovationActions(using: viewModel.sortOrder)) { action in
                        ActionRowView(renovation: renovation, action: action)
                    }
                    /*
                     We’re passed an IndexSet, not an array, and this is a special albeit rarely used collection type that is already sorted, and also only ever contains unique integers that are zero or greater.
                     When you delete a Core Data object, it doesn’t fully go away straight away – you can “delete” a whole bunch of objects in one pass, and nothing actually changes. This means our array indexing won’t change as each action is deleted, no matter what order objects are deleted in.
                     */
                    /*
                     That prints out the action count before deleting and again after deletion – if you place a breakpoint on the first print() call, you can step over the function and see it prints out the same count both times.

                     This all happens as a Core Data optimization: rather than push through all changes individually, it will hold onto them until the end of the current run loop and execute them all at once. Technically the action itself gets deleted as soon as we ask for it, but that information doesn’t get pushed through any relationships so the renovation won’t update itself immediately.
                     */
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: renovation)
                    }
                    if viewModel.showClosedRenovations == false {
                        Button {
                            withAnimation {
                                viewModel.addAction(to: renovation)
                            }
                        } label: {
                            Label(String.localizing("Add New Action", comment: "Add new action"),
                                  systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var addRenovationToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedRenovations == false {
                Button { withAnimation {
                        viewModel.addRenovation()
                }} label: {
                    // To avoid voiceover automatically say "+" as "Add" automatically
                    if UIAccessibility.isVoiceOverRunning {
                        Text(String.localizing("Add Renovation", tableName: "Renovation", comment: "Add new Renovation button"))
                    } else {
                        Label(String.localizing("Add Renovation", tableName: "Renovation", comment: "Add new Renovation button"), systemImage: "plus")
                    }
                }
            }
        }
    }

    var sortRenovationToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label(String.localizing("Sort", tableName: "Renovation", comment: "")
                      , systemImage: "arrow.up.arrow.down")
            }
        }

    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.renovations.count == 0 {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    renovationList
                }
            } // end of Group
            .navigationTitle(viewModel.showClosedRenovations ?
                                String.localizing("Closed Renovations", tableName: "Renovation", comment: ""):
                                String.localizing("Open Renovations", tableName: "Renovation", comment: ""))
            .toolbar {
                addRenovationToolbarItem
                sortRenovationToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort actions"), message: nil, buttons: [
                    .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                    .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
                    .default(Text("Title")) { viewModel.sortOrder = .title }
                ])
            }
            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
        .onOpenURL(perform: openURL)
    }



    func openURL(_ url: URL) {
        viewModel.addRenovation()
    }

}

struct RenovationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        RenovationsView(dataController: dataController, showClosedRenovations: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

        RenovationsView(dataController: dataController, showClosedRenovations: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDisplayName("iPhone 12 Pro Max landscape")
            .previewLayout(.fixed(width: 926, height: 428))
    }
}
