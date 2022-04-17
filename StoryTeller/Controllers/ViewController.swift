//
//  ViewController.swift
//  StoryTeller
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
// Inspired by Instacram login page
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // On app open, navigate to home page if user logged in
        if (user != nil) {
            let vc = HomeViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func onLoginPress(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                  return
              }
        
        //Login user with email and password
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            if error == nil {
                // Success
                strongSelf.goToHome()
            } else {
                // Failure
                strongSelf.showError(title: "Incorrect login", message: error?.localizedDescription)
            }
            
        }
    }
    
    
    @IBAction func onRegisterPress(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                  return
              }
        
        // Create user with email and password
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if error == nil {
                // Success
                strongSelf.goToHome()
            } else {
                // Failure
                strongSelf.showError(title: "Error Registering", message: error?.localizedDescription)
            }
        }
    }
    
    func goToHome() {
        print("Here")
        self.switchRootController(loggedIn: true)
    }
}

