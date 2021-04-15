//
//  HomeView.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    static let tag: String? = "Home"
    @FetchRequest(entity: Renovation.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Renovation.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var renovations: FetchedResults<Renovation>

    let actions: FetchRequest<Action>
    init() {
        let request: NSFetchRequest<Action> = Action.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Action.priority, ascending: false)
        ]
        request.fetchLimit = 10
        actions = FetchRequest(fetchRequest: request)
        // more code to come
    }

    var renovationRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: renovationRows) {
                            ForEach(renovations, content: RenovationSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }


                    VStack(alignment: .leading) {
                        ActionListView(title: "Up next"
                                       , actions: actions.wrappedValue.prefix(3)) // read first three
                        ActionListView(title: "More to explore"
                                       , actions: actions.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)

                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            

        }
        //        NavigationView {
        //            VStack {
        //                Button("Add Data") {
        //                    dataController.deleteAll()
        //                    try? dataController.createSampleData()
        //                }
        //            }
        //            .navigationTitle("Home")
        //        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDisplayName("iPhone 12 Pro Max landscape")
            .previewLayout(.fixed(width: 926, height: 428))
    }
}
