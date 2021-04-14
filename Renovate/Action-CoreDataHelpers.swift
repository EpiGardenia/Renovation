//
//  action-CoreDataHelpers.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import Foundation

extension Action {

    enum SortOrder {
        case optimized, title, creationDate
    }
    
    var actionTitle: String {
        title ?? String.localize("New Action", tableName: "CoreData", comment: "Action Title")
    }

    var actionDetail: String {
        detail ?? ""
    }

    var actionCreationDate: Date {
        creationDate ?? Date()
    }


    static var example: Action {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let action = Action(context: viewContext)
        action.title = "Example action"
        action.detail = "This is an example action"
        action.priority = 3
        action.creationDate = Date()
        return action
    }
}
