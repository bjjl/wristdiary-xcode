//
//  DateSelectionView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 13.06.21.
//

import SwiftUI

class PickerModel: ObservableObject {
    static var shared = PickerModel()
    
    @Published var selectedDay = Date().get(.day).day!
    @Published var selectedMonth = Date().get(.month).month!
}

struct DateSelectionView: View {
    private let ioManager = IOManager()
    private let days = 1...31
    private let months = 1...12
    private let monthStrings = ["", "Jan", "Feb", "Mar", "Apr", "May",
                                "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var showingEntriesView = false
    
    @ObservedObject var pm = PickerModel.shared
    
    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $pm.selectedDay) {
                    ForEach(days, id: \.self) {
                        Text(String($0))
                    }
                }
                .labelsHidden()
                Picker("", selection: $pm.selectedMonth) {
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
                                                 day: pm.selectedDay, month: pm.selectedMonth)
                    }
            }
        }
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
