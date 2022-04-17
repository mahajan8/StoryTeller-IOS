//
//  StoryTableViewCell.swift
//  StoryTeller
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var bookmarkImage: UIButton!
    
    var storyId: String = ""
    
    @IBAction func onBookmartClick(_ sender: Any) {
        // Feature yet to come
        
    }
}
