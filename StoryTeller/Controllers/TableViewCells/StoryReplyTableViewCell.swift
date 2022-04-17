//
//  StoryReplyTableViewCell.swift
//  StoryTeller
//
//  Created by Sarthak Mahajan on 2022-04-14.
//

import UIKit

class StoryReplyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // colored outer view radius
        replyView.layer.cornerRadius = 10;
        replyView.layer.masksToBounds = true;
        
        //wrap label to contain dynamic text length
        replyLabel.lineBreakMode = .byWordWrapping
        replyLabel.numberOfLines = 0
    }

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var replyView: UIView!
    
    @IBOutlet weak var replyLabel: UILabel!
    
    func alignView(type:Int) {
        //if reply added by user, display on left
        //display replies by everyone else on right
        
        if (type == 0) {
            cellView.addConstraint(NSLayoutConstraint(item: replyView as Any, attribute: .leading, relatedBy: .equal, toItem: cellView, attribute: .leading, multiplier: 1, constant: 16))

        } else {
            cellView.addConstraint(NSLayoutConstraint(item: replyView as Any, attribute: .trailing, relatedBy: .equal, toItem: cellView, attribute: .trailing, multiplier: 1, constant: -16))
            
            replyView.backgroundColor = UIColor(named: "AppGreen")
        }
    }
    
}
