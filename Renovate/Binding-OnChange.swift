//
//  Binding-OnChange.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//
/*
 OnDisappear:
 Apple does have some official guidance here, when talking about apps being moved to the background: “If your app has unsaved user data, you can save it to ensure that it isn’t lost. However, it is recommended that you save user data at appropriate points throughout the execution of your app, usually in response to specific actions.”
 */

import SwiftUI

extension Binding {
    /*
     the function we pass in to onChange() isn’t going to be used immediately, but will instead be stashed away so it can be called whenever a change finally happens. In Swift we call this an escaping function, because its usage escapes onChange() itself and will instead happen at some unknown point in the future.
     Swift needs to handle these escaping functions specially, because it needs to ensure the memory allocated to that function stays alive. This takes some extra resources, so by default functions aren’t allowed to escape – we need to add the @escaping attribute instead,
     */

    // By this extension we can use .onChange(update) instead of .onChange(of: completed) { _ in update() }
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
