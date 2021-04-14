//
//  EditRenovationView.swift
//  Renovate
//
//  Created by T  on 2021-03-09.
//

import SwiftUI



struct EditRenovationView: View {
    let renovation: Renovation
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(renovation: Renovation) {
        self.renovation = renovation

        _title = State(wrappedValue: renovation.renovationTitle)
        _detail = State(wrappedValue: renovation.renovationDetail)
        _color = State(wrappedValue: renovation.renovationColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Renovation name", text: $title.onChange(update))
                TextField("Description of this renovation", text: $detail.onChange(update))
            }

            Section(header: Text("Custom renovation color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Renovation.colors, id: \.self) { action in
                        ZStack {
                            Color(action)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)

                            if action == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }
                        .onTapGesture {
                            color = action
                            update()
                        }
                    }
                }
                .padding(.vertical)
            }

            Section(footer: Text("Closing a renovation moves it from the Open to Closed tab; deleting it removes the renovation completely.")) {
                Button(renovation.closed ?
                        String.localize("Reopen this renovation", comment:"") :
                        String.localize("Close this renovation", comment: "")) {
                    renovation.closed.toggle()
                    update()
                }

                Button(String.localize("Delete this renovation", tableName: "Renovation", comment: "under EditRenovationView")) {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle(String.localize("Edit Renovation", comment:""))
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete renovation?"), message: Text("Are you sure you want to delete this renovation? You will also delete all the actions it contains."), primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }

    func update() {
        renovation.title = title
        renovation.detail = detail
        renovation.color = color
    }

    /*
     This should delete the renovation in our active context, and also dismiss the presentation mode. Remember, dismissing this view will automatically trigger a save anyway, so we don’t need to worry about that here.
     */
    func delete() {
        dataController.delete(renovation)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditRenovationView_Previews: PreviewProvider {
    static var previews: some View {
        EditRenovationView(renovation: Renovation.example)
    }
}
