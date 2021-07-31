//
//  EntryData.swift
//  wristdiary WatchKit Extension
//
//  Created by Benjamin Lorenz on 29.05.21.
//

import Foundation

class EntryData: Decodable, ObservableObject, Identifiable {
    let _id: String
    let user_id: String
    let entry: String
    let city: String?
    let is_encrypted: Bool
    let timestamp: String
}
