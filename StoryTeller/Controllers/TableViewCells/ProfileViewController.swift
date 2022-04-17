//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Initializations
    let imagePicker = UIImagePickerController()
    private let user = Auth.auth().currentUser
    private let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // Do any additional setup after loading the view.
        
        //Set Email as user label
        userLabel.text = user?.email
        // if firbase user object contains photo url, load from the url
        if (user?.photoURL != nil) {
            profileImage.load(url: (user?.photoURL)!)
        }
    }

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // On edit click, show options to pick image
    @IBAction func editProfileClick(_ sender: Any) {
    
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Pick from Gallery", style: .default, handler: { (button) in
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                }))
                //Simalator camera crashing on camera click
//                alert.addAction(UIAlertAction(title: "Use Camera", style: .default, handler: { (button) in
//                    self.imagePicker.sourceType = .camera
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        // image png data from picked image
        guard let imageData = pickedImage.pngData() else {
            return
        }
        
        //location for storing image -> profile_images folder in firestore with userid.png as name
        let childRef = storage.child("profile_images/\(user?.uid ?? "dummy").png")
        
        //Upload image
        childRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
            guard error == nil else {
                self.showError(title: "Error", message: "Failed to upload image")
                return
            }
            
            //get image url
            childRef.downloadURL(completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                //update firebase user object with photourl
                let req = Auth.auth().currentUser?.createProfileChangeRequest()
                
                req?.photoURL = url.absoluteURL
                req?.commitChanges(completion: nil)

            })
        })
        
        profileImage.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //Go to change password
    @IBAction func onChangePasswordClick(_ sender: Any) {
        let vc = ChangePasswordViewController()
        vc.title = "Change Password"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Log out user
    @IBAction func onLogoutClick(_ sender: Any) {
        do { try Auth.auth().signOut() }
            catch { print("already logged out") }
        
        switchRootController(loggedIn: false)
    }
}
