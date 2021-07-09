//
//  DateSelectionView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 03.07.21.
//

import SwiftUI

struct DateSelectionView: View {
    @State private var date = Date()
    @State var showingEntriesView = false
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("",
                           selection: $date,
                           displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .navigationTitle("Select Day")
                
                Button("Lookup Diary") {
                    showingEntriesView = true
                }
                .padding(.top, 5)
                .sheet(isPresented: $showingEntriesView) {
                    ListEntriesView(title: "One Day")
                        .onAppear {
                            RealmDataController().readEntries(forDay: self.date)
                        }
                }
            }
        }
    }
    
    func dateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d. MMMM"
        return formatter.string(from: date)
    }
}
