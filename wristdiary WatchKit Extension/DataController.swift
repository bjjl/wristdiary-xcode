//
//  DataController.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 29.05.21.
//

import Foundation
import CryptoKit

class DataController: ObservableObject {
    static var shared = DataController()
    
    @Published var entries: [EntryData] = []
    @Published var dayEntries: [EntryData] = []
    
    var user_id = ""
    var key = SymmetricKey(size: .bits256) // TODO: get rid of this tmp key, causing trouble!
    
    init() {
        loadData()
    }
    
    func saveData() {
        DispatchQueue.global().async {
            UserDefaults.standard.setValue(self.user_id, forKey: "wristdiary_user_id")
            do {
                try GenericPasswordStore().storeKey(self.key, account: self.user_id)
            } catch {
                print("Could not save Symmetric Crypto Key: \(error)")
            }
        }
    }
    
    func importData(user_id: String, keyString: String) {
        self.user_id = user_id
        if let keyData = Data(base64Encoded: keyString) {
            let retrievedKey = SymmetricKey(data: keyData)
            self.key = retrievedKey
        }
        self.saveData()
    }

    func loadData() {
        DispatchQueue.global().async {
            if let user_id = UserDefaults.standard.object(forKey: "wristdiary_user_id") as? String {
                self.user_id = user_id
                do {
                    guard let key: SymmetricKey = try GenericPasswordStore().readKey(account: user_id)
                    else {
                        return
                    }
                    self.key = key
                } catch {
                    print("Could not read Symmetric Crypto Key: \(error)")
                }
            } else {
                self.user_id = UUID().uuidString
                self.key = SymmetricKey(size: .bits256)
                self.saveData()
            }
            let keyString = self.key.withUnsafeBytes {Data(Array($0)).base64EncodedString()}
            print("UUID: \(self.user_id), Key: \(keyString)")
        }
    }
}
