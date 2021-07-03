//
//  ListEntriesView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 21.06.21.
//

import SwiftUI
import RealmSwift

struct ListEntriesView: View {
    @StateObject var realmController = RealmDataController()
    @State var entries = RealmDataController().diaryEntries!
    @ObservedObject var viewModel = ListViewModel.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { entry in
                    if !entry.isInvalidated { // avoid crash if entry is deleted from outside
                        EntryView(entry: entry)
                    }
                }.onDelete(perform: removeRows)
            }
            .navigationTitle("My Diary")
            .listStyle(GroupedListStyle())
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        offsets.forEach ({ index in
            self.realmController.deleteEntry(object: entries[index])
        })
        viewModel.items.remove(atOffsets: offsets)
        self.realmController.readEntries()
    }
}
