//
//  EntryView.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 23.06.21.
//

import SwiftUI
import RealmSwift

struct EntryView: View {
    var entry: entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(dateAsString(date: entry.timestamp!))
                        .font(.headline)
                        .padding(1)
                    Spacer()
                }
                .background(Color.gray.opacity(0.2))
                Text(decrypt(text: entry.entry!, symmetricKey: DataController.shared.key))
            }
        }
    }
    
    func dateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d HH:mm"
        return formatter.string(from: date)
    }
}
