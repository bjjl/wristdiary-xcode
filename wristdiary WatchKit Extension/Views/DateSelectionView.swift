//
//  DateSelectionView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 13.06.21.
//

import SwiftUI

struct DateSelectionView: View {
    private let ioManager = IOManager()
    private let days = 1...31
    private let months = 1...12
    private let monthStrings = ["", "Jan", "Feb", "Mar", "Apr", "May",
                                "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var showingEntriesView = false
    @State private var selectedDay = Date().get(.day).day!
    @State private var selectedMonth = Date().get(.month).month!
    
    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $selectedDay) {
                    ForEach(days, id: \.self) {
                        Text(String($0))
                    }
                }
                .labelsHidden()
                Picker("", selection: $selectedMonth) {
                    ForEach(months, id: \.self) {
                        Text(monthStrings[$0])
                    }
                }
                .labelsHidden()
            }
            Button("Lookup Diary") {
                showingEntriesView = true
            }
            .padding(.top, 5)
            .sheet(isPresented: $showingEntriesView) {
                ListEntriesView(listForSpecificDay: true)
                    .onAppear {
                        ioManager.receiveEntries(user_id: DataController.shared.user_id,
                                                 day: selectedDay, month: selectedMonth)
                    }
            }
        }
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionView()
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
