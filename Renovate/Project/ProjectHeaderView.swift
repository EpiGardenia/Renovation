//
//  ProjectHeaderView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                    .imageScale(.large)
                    .padding(.bottom, 10)
                ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))

            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                EmptyView()
            }
        }
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
