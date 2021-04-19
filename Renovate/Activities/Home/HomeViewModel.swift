//
//  HomeViewModel.swift
//  Renovate
//
//  Created by T  on 2021-04-15.
//


import CoreData


extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let renovationsController: NSFetchedResultsController<Renovation>
        private let actionsController: NSFetchedResultsController<Action>
        
        @Published var renovations = [Renovation]()
        @Published var actions = [Action]()
        
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
            
            // Construct a fetch request to show all open renovations
            let renovationRequest: NSFetchRequest<Renovation> = Renovation.fetchRequest()
            renovationRequest.predicate = NSPredicate(format: "closed = false")
            renovationRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Renovation.title, ascending: true)]
            
            renovationsController = NSFetchedResultsController(
                fetchRequest: renovationRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            // Construct a fetch request to show the 10 highest-priority,
            // incomplete actions from open renovations.
            let actionRequest: NSFetchRequest<Action> = Action.fetchRequest()
            
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "renovation.closed = false")
            actionRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
            actionRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Action.priority, ascending: false)]
            actionRequest.fetchLimit = 10
            
            actionsController = NSFetchedResultsController(
                fetchRequest: actionRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            super.init()
            
            renovationsController.delegate = self
            actionsController.delegate = self
            
            do {
                try renovationsController.performFetch()
                try actionsController.performFetch()
                renovations = renovationsController.fetchedObjects ?? []
                actions = actionsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch initial data.")
            }
        }
    }
}
