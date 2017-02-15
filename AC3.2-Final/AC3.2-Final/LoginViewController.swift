//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Victor Zhong on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewWasTapped))
        return tap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
    }
    
    // MARK: - Functions
    
    func setTextFieldDelegate() {
        emailField.delegate = self
        passwordField.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func viewWasTapped() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    func showOKAlert(title: String, message: String?, dismissCompletion: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: dismissCompletion)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: completion)
    }
    
    // MARK: - Button Actions
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            registerButton.isEnabled = false
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("error with completion while creating new Authentication: \(error!)")
                }
                if user != nil {
                    self.showOKAlert(title: "\((user?.email)!) Created!", message: "Good Job!", dismissCompletion: {
                        action in self.performSegue(withIdentifier: "login", sender: self)
                    })
                }
                else {
                    self.showOKAlert(title: "Error", message: error?.localizedDescription)
                }
                self.registerButton.isEnabled = true
            })
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let username = emailField.text,
            let password = passwordField.text{
            loginButton.isEnabled = false
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("Error \(error)")
                }
                if user != nil {
                    self.showOKAlert(title: "\((user?.email)!) Logged In!", message: "Good Job!", dismissCompletion: {
                        action in self.performSegue(withIdentifier: "login", sender: self)
                    })
                }
                else {
                    self.showOKAlert(title: "Error", message: error?.localizedDescription)
                }
                self.loginButton.isEnabled = true
            })
        }
    }
}
