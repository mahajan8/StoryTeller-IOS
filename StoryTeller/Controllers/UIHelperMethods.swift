//
//  UIViewControllerExtensions.swift
//  Instacram
//
//  Created by Omas Abdullah on 2022-02-14.
//

import UIKit

extension UIViewController {
    func showError(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func switchRootController(loggedIn: Bool) {
        // Set rootviewcontroller based on logged in status
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabBarController = storyboard.instantiateViewController(identifier: "HomeViewController")
        
        let loginController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
        self.view.window?.rootViewController = loggedIn ? tabBarController : loginController
    }
}

extension UIImageView {
    //Load image from url
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
