//
//  ListEntriesView.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import SwiftUI

struct ListEntriesView: View {
    @ObservedObject var data = DataController.shared
    @ObservedObject var lm = LocationManager.shared

    private let ioManager = IOManager()
    
    var listForSpecificDay = false
    @State var strikethrough = [String : Bool]()

    var body: some View {
        let entries = listForSpecificDay ? data.dayEntries : data.entries

        VStack {
            if entries.count > 0 {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(entries) { entry in
                            if let city = entry.city {
                                HStack {
                                    Spacer()
                                    Text(city)
                                        .font(.system(size: 11))
                                    Spacer()
                                }
                            }
                            HStack {
                                Spacer()
                                Text(dateAsString(date: parseDate(stringDate: entry.timestamp)))
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            Text(decrypt(text: entry.entry, symmetricKey: DataController.shared.key))
                                .font(.system(size: 12))
                                .strikethrough(self.strikethrough[entry._id] ?? false)
                                .fixedSize(horizontal: false, vertical: true)
                                .onTapGesture {
                                    if !listForSpecificDay {
//                                        WKInterfaceDevice.current().play(.start)
                                        lm.requestLocation()
                                        presentInputController(completion: validate)
                                    }
                                }
                                .onLongPressGesture {
                                    if !listForSpecificDay {
                                        print("Deleting \(entry._id)")
//                                        WKInterfaceDevice.current().play(.success)
                                        self.strikethrough[entry._id] = true
                                        ioManager.deleteEntry(user_id: DataController.shared.user_id, _id: entry._id)
                                    }
                                }
                            Divider()
                        }
                    }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Text(listForSpecificDay ? "NoResults" : "Instructions")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .onTapGesture {
            if !listForSpecificDay {
//                WKInterfaceDevice.current().play(.start)
                lm.requestLocation()
                presentInputController(completion: validate)
            }
        }
    }
    
    func validate(entry: String) {
        if entry != "" {
            let encryptedEntry = encrypt(text: entry, symmetricKey: DataController.shared.key)
            ioManager.sendEntry(user_id: DataController.shared.user_id, entry: encryptedEntry, city: lm.placemark?.locality ?? "-")
        } else {
            #if targetEnvironment(simulator)
            let encryptedEntry = encrypt(text: "Ein kurzer statischer Gedanke, ausgef??hrt vom Simulator. Und fertig...", symmetricKey: DataController.shared.key)
            ioManager.sendEntry(user_id: DataController.shared.user_id, entry: encryptedEntry, city: lm.placemark?.locality ?? "-")
            #else
            print("Empty input - not sending")
            #endif
        }
    }
    
    func dateAsString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d. MMM HH:mm"
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
