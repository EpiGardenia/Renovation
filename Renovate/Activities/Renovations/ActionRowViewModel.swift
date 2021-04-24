//
//  ActionRowViewModel.swift
//  Renovate
//
//  Created by T  on 2021-04-24.
//

import Foundation

extension ActionRowView {
    class ViewModel: ObservableObject {
        init(renovation: Renovation, action: Action) {
            self.renovation = renovation
            self.action = action
        }
        
        let renovation: Renovation
        let action: Action

        var title: String {
            action.actionTitle
        }

        var icon: String{
            if action.completed {
                return "checkmark.circle"
            } else if action.priority == 3 {
                return  "exclamationmark.triangle"
            } else {
                return  "checkmark.circle"
            }
        }

        var color: String? {
            if action.completed {
                return renovation.renovationColor
            } else if action.priority == 3 {
                return renovation.renovationColor
            } else {
                return nil
            }
        }


        var label: String {
            if action.completed {
                return ("\(action.actionTitle), completed.")
            } else if action.priority == 3 {
                return ("\(action.actionTitle), high priority.")
            } else {
                return (action.actionTitle)
            }
        }

    }
}
