//
//  StoryReplyTableViewController.swift
//  StoryTeller
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StoryReplyTableViewController: UITableViewController {
        
    var storyId: String = "";
    var views: Int = 0;
    
    let database = Firestore.firestore()
    var replies:[StoryReply] = []
    
    var viewCounted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.dataSource = self
        tableView.delegate = self
        // Set automatic dimensions for row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style:.plain, target: self, action: #selector(addStoryReply))
        
        tableView.register(UINib(nibName: "StoryReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "StoryReplyTableViewCell")
        
        //Refresh control for table view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getReplies), for: .valueChanged)

        tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReplies()
    }
    
    @objc func getReplies() {
        //story id passed from previous screen to get story replies
        database.collection("stories/\(storyId)/replies").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var repliesArray:[StoryReply] = []
                // loop through documents and set StoryReply model objects in replies array to display tableview
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let message = document.get("message");
                    let userId = document.get("userId");
//                    let id = document.documentID;
                    repliesArray.append(StoryReply(message: message as! String, userId: userId as! String))
                }
                self.replies = repliesArray
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                // if replies fetch first time after opening page, increase view count
                if (!self.viewCounted) {
                    self.addViewCount()
                }
            }
        }
    }
    
    //Increase view count by 1
    func addViewCount() {
        database.collection("stories").document(storyId).updateData(["views": views + 1])
        viewCounted = true
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return replies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryReplyTableViewCell", for: indexPath) as! StoryReplyTableViewCell
        
        //mapping cell variables to values
        let reply = replies[indexPath.row]
        
        let userId = Auth.auth().currentUser?.uid
        
        cell.replyLabel.text = reply.message
        
        cell.alignView(type: userId == reply.userId ? 0 : 1)
        
        cell.selectionStyle = .none
        return cell;
    }
    
    @objc func addStoryReply () {
        let vc = AddStoryViewController();
        vc.title = "Continue the story"
        vc.storyTitle = title ?? ""
        vc.isReply = true
        vc.messagePlaceholder = "\(title ?? "") continues..."
        vc.storyId = storyId
        navigationController?.pushViewController(vc, animated: true)
    }
}
