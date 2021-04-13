//
//  ProjectsView.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//
/*
 Extra note:
 ForEach(project.projectItems, content: ItemRowView.init)
 means:
 for each item, create a new ItemRowView and pass the item in as the only parameter to the initializer

 thus can be shorthand of

 ForEach(project.projectItems) { item in
 ItemRowView(item: item)
 }

 */


import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects

        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }

    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.count == 0 {
                    Text("There's nothing here right now.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(projects.wrappedValue) { project in
                            Section(header: ProjectHeaderView(project: project)) {
                                ForEach(project.projectItems(using: sortOrder)) { item in
                                    ItemRowView(project: project, item: item)
                                }
                                /*
                                 We’re passed an IndexSet, not an array, and this is a special albeit rarely used collection type that is already sorted, and also only ever contains unique integers that are zero or greater.
                                 When you delete a Core Data object, it doesn’t fully go away straight away – you can “delete” a whole bunch of objects in one pass, and nothing actually changes. This means our array indexing won’t change as each item is deleted, no matter what order objects are deleted in.

                                 */
                                /*
                                 That prints out the item count before deleting and again after deletion – if you place a breakpoint on the first print() call, you can step over the function and see it prints out the same count both times.

                                 This all happens as a Core Data optimization: rather than push through all changes individually, it will hold onto them until the end of the current run loop and execute them all at once. Technically the item itself gets deleted as soon as we ask for it, but that information doesn’t get pushed through any relationships so the project won’t update itself immediately.
                                 */
                                .onDelete { offsets in
                                    let allItems = project.projectItems(using: sortOrder)
                                    //print(project.projectItems.count)  // value are the same

                                    for offset in offsets {
                                        let item = allItems [offset]
                                        dataController.delete(item)
                                    }

                                    // With the next line, it delete immediately
                                    // dataController.container.viewContext.processPendingChanges()
                                    //print(project.projectItems.count)  // value are the same
                                    dataController.save()
                                }
                                if showClosedProjects == false {
                                    Button {
                                        withAnimation {
                                            let item = Item(context: managedObjectContext)
                                            item.project = project
                                            item.creationDate = Date()
                                            dataController.save()
                                        }
                                    } label: {
                                        Label("Add New Item", systemImage: "plus")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            } // end of Group
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProjects == false {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
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
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDisplayName("iPhone 12 Pro Max landscape")
            .previewLayout(.fixed(width: 926, height: 428))
    }
}
