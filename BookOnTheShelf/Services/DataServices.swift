//
//  DataServices.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import Foundation
import RealmSwift

class DataServices {
    
    private init(){}
    static let shared = DataServices()
    
    //Configure Database access
    private var realm: Realm {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        return try! Realm(configuration: config!)
    }
    
    // Sign In the user
    func signIn(email: String, password: String, register: Bool, completion: @escaping (Result<User, Error>) -> ()) {
        
        for user in SyncUser.all {
            debugPrint("user: \(user.key) - \(user.value)")
            user.value.logOut()
        }
        
        let credentials = SyncCredentials.usernamePassword(username: email, password: password, register: register)
        SyncUser.logIn(with: credentials, server: Constants.AUTH_URL!) { [unowned self] (user, error) in
            if let error = error {
                // Auth error: user already exists? Try logging in as that user.
                print("Login failed: \(error)")
                completion(.failure(error))
                return
            }
            guard let user = user else { return }
            
            var signedUser = User()
            signedUser.initialize(id: user.identity ?? "", email: email)
            if register {
                self.registerUser(id: signedUser.id, email: signedUser.email)
                completion(.success(signedUser))
            } else {
                self.loadUser(primaryKey: signedUser.id) { (result) in
                    switch result {
                    case .success(let user):
                        signedUser = user
                        completion(.success(signedUser))
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
            
        }
    }
    
    //Register a new user
    private func registerUser(id: String, email: String) {
        let newUser = User()
        newUser.initialize(id: id, email: email)
        self.write(object: newUser)
    }
    
    //Write to Database
    func write(object: Any) {
        
        if object is Book {
            
        }
        do {
            try DataServices.shared.realm.write {
                switch object {
                case is Book:
                    DataServices.shared.realm.add(object as! Book)
                case is User:
                    DataServices.shared.realm.add(object as! User)
                default:
                    return
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // load user data
    func loadUser(primaryKey: String?, completion: @escaping (Result<User, Error>) -> Void) {
        let item = realm.object(ofType: User.self, forPrimaryKey: primaryKey)!
        completion(.success(item))
    }
    
    // load books data
    func loadBooks(completion: @escaping (Results<Book>) -> Void) {
        let books: Results<Book> = realm.objects(Book.self).sorted(byKeyPath: "title", ascending: true)
        completion(books)
    }
}
