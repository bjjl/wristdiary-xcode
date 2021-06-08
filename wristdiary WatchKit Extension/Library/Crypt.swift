//
//  Crypt.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 28.05.21.
//

import Foundation
import CryptoKit

func encrypt(text: String, symmetricKey: SymmetricKey) -> String {
    let textData = text.data(using: .utf8)!
    do {
        let encrypted = try ChaChaPoly.seal(textData, using: symmetricKey)
        return encrypted.combined.base64EncodedString()
    } catch {
        return ""
    }
}

func decrypt(text: String, symmetricKey: SymmetricKey) -> String {
    do {
        guard let data = Data(base64Encoded: text) else {
            return text // decoding failed - return original text
        }
        
        let sealedBox = try ChaChaPoly.SealedBox(combined: data)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
        
        guard let text = String(data: decryptedData, encoding: .utf8) else {
            return "Could not decode data: \(decryptedData)"
        }
        
        return text
    } catch let error {
        return "Error decrypting message: \(error.localizedDescription)"
    }
}
