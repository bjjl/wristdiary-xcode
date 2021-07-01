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
    
    init() {
        realmInit()
        
        if let entries = diaryEntries {
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
                let realm = try! Realm(configuration: configuration)
                print("Realm opened: \(realm)")
                self.realm = realm
                self.readEntries()
            }
        }
    }
    
    func readEntries() {
        self.diaryEntries = realm!.objects(entry.self)
            .sorted(byKeyPath: "timestamp", ascending: false)
        ListViewModel.shared.items = self.diaryEntries!.toArray(ofType: entry.self) as [entry]
    }
    
    func deleteEntry(object: Object) {
        try! self.realm!.write {
            self.realm!.delete(object)
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let max = 50
        var array = [T]()
        for i in 0 ..< (count < max ? count : max) {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
