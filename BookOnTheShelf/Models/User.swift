//
//  User.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic public private (set) var id: String!
    @objc dynamic public private (set) var email: String!
    
    func initialize(id: String, email: String) {
        self.id = id
        self.email = email
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
