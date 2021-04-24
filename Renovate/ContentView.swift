//
//  ContentView.swift
//  Renovate
//
//  Created by T  on 2021-03-08.
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    /*
     The “selectedView” string is the name of the UserDefaults key we want to read and write, and although it doesn’t need to match the property name I find it useful just to aid my memory. If you use that same string name in several places, they will all automatically update as the underlying value is changed.
     Using an optional for selectedView is helpful because it means it will have no value by default, and so whatever is the first tab will be selected when the app first runs.
     try changing tabs in one of the apps, and you’ll notice the other app changes to the same tab automatically. This is a really neat feature, because you can see exactly how @AppStorage stashes the data away and correctly updates all your UI.
     @AppStorage("selectedView") var selectedView: String?

     => so we use @SceneStorage so not all device app behave simutaneously

     Three critical difference:

     Values you save are attached to the current instance of your app rather than your whole app, which means if you have two instances of an app like on iPad each will have their own scene storage.
     If the user actively terminates your app, the data gets deleted. This means they go to the app switcher, and swipe to delete your app.
     It uses SwiftUI’s state restoration system rather than UserDefaults, so it won’t clash with any other data you’re writing into UserDefaults.

     */
    @SceneStorage("selectedView") var selectedView: String?
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            RenovationsView(dataController: dataController, showClosedRenovations: false)
                .tag(RenovationsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            RenovationsView(dataController: dataController, showClosedRenovations: true)
                .tag(RenovationsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
        }
        // Sportlight
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
