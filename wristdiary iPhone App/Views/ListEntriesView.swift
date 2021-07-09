//
//  ListEntriesView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 21.06.21.
//

import SwiftUI
import RealmSwift

struct ListEntriesView: View {
    @StateObject var realmController = RealmDataController(readEntriesAfterInit: true) // required to make entries.observe() fire an event in case of changes from external
    @State var entries = RealmDataController(readEntriesAfterInit: true).diaryEntries
    @ObservedObject var viewModel = ListViewModel.shared
    
    var title = "My Diary"
    
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.items) { entry in
                        if !entry.isInvalidated { // avoid crash if entry is deleted from outside
                            EntryView(entry: entry)
                        }
                    }.onDelete(perform: removeRows)
                }
                .navigationTitle(self.title)
                .listStyle(GroupedListStyle())
                
                Divider()
                
                TextField("", text: $text, onCommit: {
                    RealmDataController().addEntry(text: text)
                    text = ""
                    UIApplication.shared.endEditing()
                })
                .font(.system(size: 20))
                .padding()
                .padding(.bottom, 12)
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        if let nonNilEntries = self.entries {
            print("removeRows: \(offsets)")
            offsets.forEach ({ index in
                RealmDataController().deleteEntry(object: nonNilEntries[index])
            })
            viewModel.items.remove(atOffsets: offsets)
            RealmDataController().readEntries()
        } else {
            print("removeRows: entries is nil")
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
