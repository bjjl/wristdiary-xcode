//
//  EntryData.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 29.05.21.
//

import Foundation

class EntryData: Decodable, ObservableObject, Identifiable {
    let user_id: String
    let entry: String
    let is_encrypted: Bool
    //let timestamp: Int64 // let timestamp = Date().currentTimeMillis()
    let timestamp: String
}
