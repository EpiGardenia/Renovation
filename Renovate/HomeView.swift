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
                            ForEach(renovations) { renovation in
                                VStack(alignment: .leading) {
                                    Text("\(renovation.renovationActions.count) Actions")
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(renovation.renovationTitle)
                                        .font(.title2)

                                    ProgressView(value: renovation.completionAmount)
                                        .accentColor(Color(renovation.renovationColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                                // by using .combine, it reads according to default order
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("\(renovation.renovationTitle), \(renovation.renovationActions.count) actions, \(renovation.completionAmount*100, specifier: "%g")% complete")

                            }
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }


                    VStack(alignment: .leading) {
                        list(String.localize("Up next", comment: ""), for: actions.wrappedValue.prefix(3)) // read first three
                        list(String.localize("More to explore", comment: ""), for: actions.wrappedValue.dropFirst(3))
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

    @ViewBuilder func list(_ title: String, for actions: FetchedResults<Action>.SubSequence) -> some View {
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
