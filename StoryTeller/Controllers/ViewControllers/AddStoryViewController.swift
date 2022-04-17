//
//  AddStoryViewController.swift
//  StoryTeller
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddStoryViewController: UIViewController, UITextViewDelegate {
    
    var isReply = false
    var storyTitle = ""
    var storyId = ""
    var messagePlaceholder = "Start your story here.."

    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    let database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set curver border for textview
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor;
        messageTextField.layer.borderWidth = 1.0;
        messageTextField.layer.cornerRadius = 8;
        
        //Setting Placeholder for textview
        messageTextField.delegate = self
        messageTextField.text = messagePlaceholder
        messageTextField.textColor = UIColor.lightGray
        
        //Screen reused, disable title and mark is Reply for Add Story Reply screen
        if (isReply) {
            titleTextField.text = storyTitle
            titleTextField.isEnabled = false
        }
    }
    
    //if textcolor is gray, empty textview and switch color to black to hold real text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextField.textColor == UIColor.lightGray {
            messageTextField.text = nil
            messageTextField.textColor = UIColor.black
        }
    }
    
//    if textview empty, switch color back to gray and set text to placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = messagePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func onStoryAdd(_ sender: Any) {
        guard let title = titleTextField.text,
              let message = messageTextField.text else {
                  return
              }
        
        let userId = Auth.auth().currentUser?.uid
        
        var doc: DocumentReference? = nil
        
        if (!isReply) {
            //Add document with story title to collection stories if new story
            doc = database.collection("stories").addDocument(data: [
                "title": title,
                "views": 0
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added")
                    
                    //set story id as the document added
                    self.storyId = doc?.documentID ?? ""
                    self.addReplyCollection(message: message, userId: userId ?? "")
                }
            }
        } else if (storyId != ""){
            // if adding reply, storyId is passed from previous screen
            self.addReplyCollection(message: message, userId: userId ?? "")
        } else {
            showError(title: "Error", message: "Unable to add reply. Pleae try again later.")
        }
    }
    
    func addReplyCollection(message: String, userId: String) {
        
        // add document with story message and user id under replies collection
        
        //Firebase db heirarchy
        // Collection stories -> holds documents with title and view count and a collection 'replies' that holds all story replies with user ids
        
        
        self.database.collection("stories").document(storyId).collection("replies").addDocument(data: [
            "message": message,
            "userId": userId
        ]) { err in
            if let err = err {
                print("Error adding replies: \(err)")
            } else {
                
                let alertController = UIAlertController(title: "Success", message: "Story has been created", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: goBack))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        func goBack(alert: UIAlertAction!) {
            navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
