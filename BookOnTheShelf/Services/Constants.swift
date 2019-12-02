//
//  Constants.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation

struct Constants {

    static let MY_INSTANCE_ADDRESS = "publickey-bookontheshelf.us1.cloud.realm.io"
    static let AUTH_URL = URL(string: "https://\(MY_INSTANCE_ADDRESS)")
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/ToDo")
}
