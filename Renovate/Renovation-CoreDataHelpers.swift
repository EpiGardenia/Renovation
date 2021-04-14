//
//  Renovation-CoreDataHelpers.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import Foundation
extension Renovation {

    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

    var renovationTitle: String {
        title ?? String.localize("NEW RENOVATION", tableName: "Core", comment: "")
    }

    var renovationDetail: String {
        detail ?? ""
    }

    var renovationColor: String {
        color ?? "Light Blue"
    }

    var renovationActions: [Action] {
        actions?.allObjects as? [Action] ?? []
    }

    var renovationActionsDefaultSorted: [Action] {
        renovationActions.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.actionCreationDate < second.actionCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalActions = actions?.allObjects as? [Action] ?? []
        guard originalActions.isEmpty == false else { return 0 }

        let completedActions = originalActions.filter(\.completed)
        return Double(completedActions.count) / Double(originalActions.count)
    }

    func renovationActions(using sortOrder: Action.SortOrder) -> [Action] {
        switch sortOrder {
            case .title:
                return renovationActions.sorted(by: \Action.actionTitle)
            case .creationDate:
                return renovationActions.sorted(by: \Action.actionCreationDate)
            case .optimized:
                return renovationActionsDefaultSorted
        }
    }

    static var example: Renovation {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let renovation = Renovation(context: viewContext)
        renovation.title = "Example Renovation"
        renovation.detail = "This is an example renovation"
        renovation.closed = true
        renovation.creationDate = Date()
        return renovation
    }
}
