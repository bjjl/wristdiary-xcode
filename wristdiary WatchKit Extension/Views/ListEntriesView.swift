//
//  ListEntriesView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import SwiftUI

struct ListEntriesView: View {
    @ObservedObject var data = DataController.shared
    private let ioManager = IOManager()
    
    var listForSpecificDay = false
    
    var body: some View {
        let entries = listForSpecificDay ? data.dayEntries : data.entries

        VStack {
            if entries.count > 0 {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(entries) { entry in
                            Text(dateAsString(date: parseDate(stringDate: entry.timestamp)))
                            Text(decrypt(text: entry.entry, symmetricKey: DataController.shared.key))
                                .font(.footnote)
                                .fixedSize(horizontal: false, vertical: true)
                            Divider()
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Text(listForSpecificDay ? "No diary entries\nfor this day" :
                            "Empty diary\n\nLong press to create your first entry")
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .onTapGesture {  }
        .onLongPressGesture {
            presentInputController(completion: validate)
        }
    }
    
    func validate(entry: String) {
        if entry != "" {
            let encryptedEntry = encrypt(text: entry, symmetricKey: DataController.shared.key)
            ioManager.sendEntry(user_id: DataController.shared.user_id, entry: encryptedEntry)
        } else {
            #if targetEnvironment(simulator)
            let encryptedEntry = encrypt(text: "Ein kurzer statischer Gedanke, ausgeführt vom Simulator. Und fertig...", symmetricKey: DataController.shared.key)
            ioManager.sendEntry(user_id: DataController.shared.user_id, entry: encryptedEntry)
            #else
            print("Empty input - not sending")
            #endif
        }
    }
    
    func dateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d HH:mm"
        return formatter.string(from: date)
    }
    
    func parseDate(stringDate: String) -> Date {
        // Sat, 29 May 2021 15:45:01 GMT
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "E, dd MM yyyy HH:mm:ss ZZZ"
        let date = dateFormatter.date(from:stringDate)!
        return date
    }
}

extension View {
    typealias StringCompletion = (String) -> Void
    
    func presentInputController(completion: @escaping StringCompletion) {
        WKExtension.shared()
            .visibleInterfaceController?
            .presentTextInputController(withSuggestions: nil,
                                        allowedInputMode: .plain) { result in
                guard let result = result as? [String], let firstElement = result.first else {
                    completion("")
                    return
                }
                completion(firstElement)
            }
    }
}
