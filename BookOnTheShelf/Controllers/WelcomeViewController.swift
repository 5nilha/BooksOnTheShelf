//
//  WelcomeViewController.swift
//  BookOnTheShelf
//
//  Created by Fabio Quintanilha on 12/1/19.
//  Copyright © 2019 FabioQuintanilha. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailFieldView: UIView!
    @IBOutlet weak var emailIconView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordFieldView: UIView!
    @IBOutlet weak var passwordIconView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Configure the activity indicator.
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        self.emailField.placeholder = "Email"
        self.emailFieldView.rounded()
        self.emailFieldView.border(width: 1, color: #colorLiteral(red: 0.823651135, green: 0.8187556863, blue: 0.8274146914, alpha: 1))
        self.emailIconView.circle()
       
        self.passwordField.placeholder = "Password"
        self.passwordField.isSecureTextEntry = true
        self.passwordFieldView.rounded()
        self.passwordFieldView.border(width: 1, color: #colorLiteral(red: 0.823651135, green: 0.8187556863, blue: 0.8274146914, alpha: 1))
        self.passwordIconView.circle()
        
        self.signInButton.rounded()
        self.signUpButton.rounded()
        self.signUpButton.border(width: 2, color: .black)
        self.errorLabel.isHidden = true
        
    }
    
    
    // Turn on or off the activity indicator.
    func setLoading(_ loading: Bool) {
        if (loading) {
            activityIndicator.startAnimating()
            errorLabel.text = ""
        }
        else {
            activityIndicator.stopAnimating()
        }
        
        self.emailField.isEnabled = !loading
        self.passwordField.isEnabled = !loading
        self.signInButton.isEnabled = !loading
        self.signUpButton.isEnabled = !loading
        
    }
    
    func login(email: String, password: String, register: Bool) {
        print("Log in as user: \(email) with register: \(register)")
        self.setLoading(true)
        
        DataServices.shared.signIn(email: email, password: password, register: register) { (result) in
            switch result {
            case .success(let user):
                self.errorLabel.isHidden = true
                print("Login succeeded!");
                self.performSegue(withIdentifier: "goToBookList", sender: nil)
                self.setLoading(false)
                break
            case .failure(let error):
                //Auth error: user already exists? Try logging in as that user.
                print("Login failed: \(error)")
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Login failed: \(error.localizedDescription)"
                self.setLoading(false)
                break
            }
        }
    }
    
    @IBAction func SignUpTapped() {
        let email = self.emailField.text ?? ""
        let password = self.passwordField.text ?? ""
        
        if !email.isEmpty && !password.isEmpty {
            login(email: email, password: password, register: true)
        }
    }
    
    @IBAction func signInTapped() {
        let email = self.emailField.text ?? ""
        let password = self.passwordField.text ?? ""

        if !email.isEmpty && !password.isEmpty {
            login(email: email, password: password, register: false)
        }
    }
    
}

