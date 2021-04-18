//
//  HomeViewModel.swift
//  Renovate
//
//  Created by T  on 2021-04-15.
//

import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let RenovationController: NSFetchedResultsController<Renovate>
        private let ActionController: NSFetchedResultsController<Action>

        @Published var renovations = [Renovate]()
        @Published var actions = [Action]()

        var dataController: DataController {
            self.dataController = dataController
            l
        }


    }
}
