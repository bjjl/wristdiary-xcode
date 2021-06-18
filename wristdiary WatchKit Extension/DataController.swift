//
//  DataController.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 29.05.21.
//

import Foundation
import CryptoKit
import KeychainAccess

class DataController: ObservableObject {
    static var shared = DataController()
    
    @Published var entries: [EntryData] = []
    @Published var dayEntries: [EntryData] = []
    
    let keychainServiceName = "com.pocketservices.wristdiary"
    let keychainUserIdAccount = "0b94b253"
    let keychainKeyAccount = "718d0493"
    
    var user_id = ""
    var key = SymmetricKey(size: .bits256) // TODO: get rid of this tmp key, causing trouble!
    
    init() {
        loadData()
    }
    
    func saveData() {
        DispatchQueue.global().async {
            let keychain = Keychain(service: self.keychainServiceName).synchronizable(true)
            keychain[self.keychainUserIdAccount] = self.user_id
            keychain[self.keychainKeyAccount] = self.key.withUnsafeBytes { Data(Array($0)).base64EncodedString() }
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
            let keychain = Keychain(service: self.keychainServiceName).synchronizable(true)
            if let user_id = keychain[self.keychainUserIdAccount] {
                self.user_id = user_id
                if let keyData = Data(base64Encoded: keychain[self.keychainKeyAccount]!) {
                    let retrievedKey = SymmetricKey(data: keyData)
                    self.key = retrievedKey
                }
            } else {
                print("Setting up Identity in iCloud Keychain")
                self.user_id = UUID().uuidString
                self.key = SymmetricKey(size: .bits256)
                self.saveData()
            }
            let keyString = self.key.withUnsafeBytes { Data(Array($0)).base64EncodedString() }
            print("UUID: \(self.user_id), Key: \(keyString)")
        }
    }
}
