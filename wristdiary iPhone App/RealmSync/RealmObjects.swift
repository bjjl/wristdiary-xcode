//
//  RealmObjects.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 21.06.21.
//

import Foundation
import RealmSwift

final class entry: Object, ObjectKeyIdentifiable {
    @objc dynamic var _id: ObjectId? = nil
    @objc dynamic var entry: String? = nil
    let is_encrypted = RealmProperty<Bool?>()
    @objc dynamic var timestamp: Date? = nil
    @objc dynamic var user_id: String? = nil
    override static func primaryKey() -> String? {
        return "_id"
    }
}
