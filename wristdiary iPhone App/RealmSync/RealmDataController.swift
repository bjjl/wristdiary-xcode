//
//  RealmDataController.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 22.06.21.
//

import Foundation
import RealmSwift

class RealmDataController: ObservableObject {
    
    let realmApp = RealmSwift.App(id: "wristdiary-eqqxb")
    @Published var diaryEntries: Results<entry>?
    var token: NotificationToken? = nil
    
    @Published var realm: Realm?
    
    var readEntriesAfterInit = false
    
    init(readEntriesAfterInit: Bool? = false) {
        if let nonNilreadEntriesAfterInit = readEntriesAfterInit {
            self.readEntriesAfterInit = nonNilreadEntriesAfterInit
        }
        
        realmInit()
        
        if let entries = diaryEntries {
            print("Activating Observer \(entries.count)")
            token = entries.observe({ [unowned self] (changes) in
                switch changes {
                case .error(_): break
                case .update(_,_,_,_):
                    print("Update Observer has fired!")
                    ListViewModel.shared.items = self.diaryEntries!.toArray(ofType: entry.self) as [entry]
                    self.objectWillChange.send()
                case .initial(_): self.objectWillChange.send()
                }
            })
        }
    }
    
    func realmInit() {
        realmApp.login(credentials: Credentials.anonymous) { (result) in
            switch result {
            case .failure(let error):
                print("Login failed: \(error)")
            case .success(let user):
                print("Login as \(user) succeeded!")
                let partitionValue = DataController.shared.user_id
                print("Realm Sync Partition Value: \(partitionValue)")
                // Get a sync configuration from the user object.
                let configuration = user.configuration(partitionValue: partitionValue)
                let tmpRealm = try! Realm(configuration: configuration)
                print("Realm opened: \(tmpRealm)")
                self.realm = tmpRealm
                if self.readEntriesAfterInit {
                    self.readEntries()
                }
            }
        }
    }
    
    func readEntries(forDay: Date? = nil) {
        if let nonNilRealm = self.realm {
            var tmp: Results<entry>?
            if let timestamp = forDay {
                let dayStart = Calendar.current.startOfDay(for: timestamp)
                let dayEnd: Date = {
                    let components = DateComponents(day: 1, second: -1)
                    return Calendar.current.date(byAdding: components, to: dayStart)!
                }()
                tmp = nonNilRealm.objects(entry.self).filter("timestamp BETWEEN %@", [dayStart, dayEnd])
                    .sorted(byKeyPath: "timestamp", ascending: false)
                self.diaryEntries = tmp
            } else {
                tmp = nonNilRealm.objects(entry.self)
                    .sorted(byKeyPath: "timestamp", ascending: false)
                self.diaryEntries = tmp
            }
            print("readEntries: \(tmp!.count)")
            ListViewModel.shared.items = tmp!.toArray(ofType: entry.self) as [entry]
        } else {
            print("readEntries - Realm is nil")
        }
    }
    
    func addEntry(text: String) {
        if text != "" {
            print("addEntry START")
            let encryptedEntry = encrypt(text: text, symmetricKey: DataController.shared.key)

            let newEntry = entry()
            newEntry._id = ObjectId.generate()
            newEntry.entry = encryptedEntry
            newEntry.is_encrypted.value = true
            newEntry.timestamp = Date()
            newEntry.user_id = DataController.shared.user_id
            
            try! self.realm!.write {
                self.realm!.add(newEntry.self)
                print("addEntry - text added to realm")
            }
            
            readEntries()
        }
    }

    func deleteEntry(object: Object) {
        try! self.realm!.write {
            self.realm!.delete(object)
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let max = 100
        var array = [T]()
        for i in 0 ..< (count < max ? count : max) {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
