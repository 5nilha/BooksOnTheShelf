//
//  BookListViewController.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit
import RealmSwift

class BookListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    
    var books: Results<Book>!
    var filteredBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        loadBooks()
        
        self.searchBar.placeholder = "by name, category"
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(rightBarButtonDidClick))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Book", style: .plain, target: self, action: #selector(leftBarButtonDidClick))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func loadBooks() {
        DataServices.shared.loadBooks { (results) in
            print(" books \(results.count)")
            self.books = results
            self.filteredBooks.removeAll()
            self.filteredBooks.append(contentsOf: self.books)
            self.tableView.reloadData()
        }
    }

    @objc func rightBarButtonDidClick() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (alert) in
            SyncUser.current?.logOut()
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func leftBarButtonDidClick() {
        let alertController = UIAlertController(title: "Add Book", message: "", preferredStyle: .alert)
        
        // Add TextFields
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "New Book Name"
        }
        
        alertController.addTextField { (textField: UITextField) in
                   textField.placeholder = "Author Name"
        }
        
        alertController.addTextField { (textField: UITextField) in
                   textField.placeholder = "Number of Pages"
        }
        
        
        // Add Actions
        let action = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            guard let textFields = alertController.textFields else { return }
            if textFields.count <= 3 {
                let titleField = textFields[0] as UITextField
                let authorField = textFields[1] as UITextField
                let pagesField = textFields[2] as UITextField
                
                let book = Book()
                book.title = titleField.text ?? ""
                book.authorName = authorField.text ?? ""
                book.numOfPages = Int(pagesField.text ?? "0") ?? 0
                DataServices.shared.write(object: book)
                self.loadBooks()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BookListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filteredBooks = self.books.filter { (book) -> Bool in
                return book.title.contains(searchText) || book.authorName.contains(searchText)
            }
        }
        else {
            self.filteredBooks.removeAll()
            self.filteredBooks.append(contentsOf: books)
        }
        self.tableView.reloadData()
    }
    
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        cell.selectionStyle = .none
        let book = filteredBooks[indexPath.row]
        cell.setupCell(book: book)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = filteredBooks[indexPath.row]
        print(book.title)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

