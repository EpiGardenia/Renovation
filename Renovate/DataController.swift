//
//  DataController.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data
    let container: NSPersistentCloudKitContainer

    /// The UserDefaults suite where we're saving user data
    let defaults: UserDefaults


    /// Loads and saves whether our premium unlock has been purchased
    var fullVersionUnlocked: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")

        }
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }

    /// Initialized a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage ( for use in regular app runs)
    ///
    /// Defaults to permanent storage:
    /// - Parameter inMemory: Wheter to store this data in temporary memory or not
    /// - Parameter defaults: The UserDefaults suite where user data should be stored

    init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults

        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }

    }

    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...5 {
            let renovation = Renovation(context: viewContext)
            renovation.title = "Renovation \(i)"
            renovation.actions = []
            renovation.creationDate = Date()
            renovation.closed = Bool.random()

            for j in 1...10 {
                let action = Action(context: viewContext)
                action.title = "Action \(j)"
                action.creationDate = Date()
                action.completed = Bool.random()
                action.renovation = renovation
                action.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Action.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Renovation.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
            case "actions":
                let fetchRequest: NSFetchRequest<Action> = NSFetchRequest(entityName: "Action")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            case "complete":
                let fetchRequest: NSFetchRequest<Action> = NSFetchRequest(entityName: "Action")
                fetchRequest.predicate = NSPredicate(format: "completed = true")
                let awardCount = count(for: fetchRequest)
                return awardCount >= award.value

            default:
                // fatalError("Unknown award criterion \(award.criterion).")
                return false
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
}
