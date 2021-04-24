//
//  HomeView.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import SwiftUI
import CoreData
import CoreSpotlight

struct HomeView: View {
    @StateObject var viewModel: ViewModel
    static let tag: String? = "Home"

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var renovationRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                // If tag == selection, go directly to EditActionView
                if let action = viewModel.selectedAction {
                    NavigationLink(
                        destination: EditActionView(action: action),
                        tag: action,
                        selection: $viewModel.selectedAction,
                        label: EmptyView.init
                    )
                    .id(action)
                }
                
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: renovationRows) {
                            ForEach(viewModel.renovations, content: RenovationSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading) {
                        ActionListView(title: "Up next"
                                       , actions: viewModel.upNext) // read first three
                        ActionListView(title: "More to explore"
                                       , actions: viewModel.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)


        }
    }


    /* MARK: Spotlight */
    // Accept any kind of userActivity
    // If it meets our unique identifier, pass to viewmodel
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        // if userInfo directory exists, key CSSearchableItemActivityIdentifier exist,
        // if value is a string, we pass it to viewModel
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectAction(with: uniqueIdentifier)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView(dataController: .preview)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

        HomeView(dataController: .preview)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .previewDisplayName("iPhone 12 Pro Max landscape")
            .previewLayout(.fixed(width: 926, height: 428))
    }
}
