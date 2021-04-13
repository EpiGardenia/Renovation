//
//  RenovateApp.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//
/*
 This is where our main content view is created, and we can use this to watch for the notification UIApplication.willResignActiveNotification being posted – that will happen as soon as the user leaves the app, even just if they have entered multitasking mode.
 */
import SwiftUI

@main
struct RenovateApp: App {
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager
    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                // so the change is saved if user leave the app in the middle of editing
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }

    /*
        We can’t call dataController.save() directly here because the method will want to pass in a Notification object with more information. So, instead we’re going to add this little shim method to our UltimatePortfolioWorkingApp struct that bridges the two:
     */

    func save(_ note: Notification) {
        dataController.save()
    }
}
