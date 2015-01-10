//
//  TweetCell.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet var imageButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var favoriteLabel: UILabel!

    var networkController = NetworkContoller()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func imageButtonPressed(sender: UIButton) {
        println("image button pressed")
        
    }
}
