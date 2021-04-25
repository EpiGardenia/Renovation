//
//  RenovationViewModel.swift
//  Renovate
//
//  Created by T  on 2021-04-15.
//

import CoreData
import Foundation

extension RenovationsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Action.SortOrder.optimized
        let showClosedRenovations: Bool

        private let renovationController: NSFetchedResultsController<Renovation>
        @Published var renovations = [Renovation]()

        @Published var showingUnlockView = false

        init(dataController: DataController, showClosedRenovations: Bool) {
            self.showClosedRenovations = showClosedRenovations
            self.dataController = dataController
            let request: NSFetchRequest<Renovation> = Renovation.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Renovation.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedRenovations)

            renovationController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: dataController.container.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)

            super.init()
            renovationController.delegate = self

            do {
                try renovationController.performFetch()
                renovations = renovationController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our projects!")
            }

        }

        // the update will pass to view via @Published
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newRenovations = controller.fetchedObjects as? [Renovation] {
                renovations = newRenovations
            }
        }

        func addRenovation() {
            if dataController.addRenovation() == false {
                showingUnlockView.toggle()
            }
//            let canCreate = dataController.fullVersionUnlocked || (dataController.count(for: Renovation.fetchRequest()) < 3)
//            if canCreate {
//                let renovation = Renovation(context: dataController.container.viewContext)
//                renovation.closed = false
//                renovation.creationDate = Date()
//                dataController.save()
//            } else {
//                showingUnlockView.toggle()
//            }
        }

        func addAction(to renovation: Renovation){
                let action = Action(context: dataController.container.viewContext)
                action.renovation = renovation
                action.creationDate = Date()
                dataController.save()
        }

        func delete(_ offsets: IndexSet, from renovation: Renovation) {
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
    }
}
