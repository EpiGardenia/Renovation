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
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingSortOrder = false
    @State private var sortOrder = Action.SortOrder.optimized
    let showClosedRenovations: Bool
    let renovations: FetchRequest<Renovation>
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    init(showClosedRenovations: Bool) {
        self.showClosedRenovations = showClosedRenovations

        renovations = FetchRequest<Renovation>(entity: Renovation.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Renovation.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedRenovations))
    }

    var body: some View {
        NavigationView {
            Group {
                if renovations.wrappedValue.count == 0 {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(renovations.wrappedValue) { renovation in
                            Section(header: RenovationHeaderView(renovation: renovation)) {
                                ForEach(renovation.renovationActions(using: sortOrder)) { action in
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
                                    let allActions = renovation.renovationActions(using: sortOrder)
                                    //print(renovation.renovationactions.count)  // value are the same

                                    for offset in offsets {
                                        let action = allActions [offset]
                                        dataController.delete(action)
                                    }

                                    // With the next line, it delete immediately
                                    // dataController.container.viewContext.processPendingChanges()
                                    //print(renovation.renovationActions.count)  // value are the same
                                    dataController.save()
                                }
                                if showClosedRenovations == false {
                                    Button {
                                        withAnimation {
                                            let action = Action(context: managedObjectContext)
                                            action.renovation = renovation
                                            action.creationDate = Date()
                                            dataController.save()
                                        }
                                    } label: {
                                        Label("Add New Action", systemImage: "plus")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            } // end of Group
            .navigationTitle(showClosedRenovations ? "Closed Renovations" : "Open Renovations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedRenovations == false {
                        Button {
                            withAnimation {
                                let renovation = Renovation(context: managedObjectContext)
                                renovation.closed = false
                                renovation.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Renovation", systemImage: "plus")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort actions"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
            SelectSomethingView()
        }
    }
}

struct RenovationsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        RenovationsView(showClosedRenovations: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

        RenovationsView(showClosedRenovations: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDisplayName("iPhone 12 Pro Max landscape")
            .previewLayout(.fixed(width: 926, height: 428))
    }
}
