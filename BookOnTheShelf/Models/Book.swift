//
//  Book.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation
import RealmSwift

enum BookCategory: String, CaseIterable {
    case business
    case science
    case programming
    case engineering
}

class Book: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var numOfPages: Int = 0
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var category: String = ""
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
//    init(id: String, title: String, authorName: String, numPages: Int, category: BookCategory) {
//        self.id = id
//    }
}
