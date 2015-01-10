//
//  DetailViewController.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var networkController: NetworkContoller!
    
    var tweet: Tweet!
    
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var favoriteLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var retweetLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkController.fetchTweet(tweet, completionHandler: { (infoDictionary, error) -> () in
        
            
            if error == nil {
                self.tweet.updateWithInfo(infoDictionary!)
//                let tweet = Tweet(infoDictionary!)
                
                self.usernameLabel.text = self.tweet.user_name
                self.tweetLabel.text = self.tweet.text
                self.screennameLabel.text = "@\(self.tweet.user_screenName)"
                self.retweetLabel.text = "\(self.tweet.retweetCount!) retweets"
                self.favoriteLabel.text = "\(self.tweet.favoriteCount!) favorited"

                if self.tweet.user_image == nil {
                    self.networkController.fetchImage(self.tweet, completionHandler: { (image) -> () in
                        self.tweet.user_image = image
                        self.imageButton.setImage(self.tweet.user_image, forState: .Normal)
                    })
                } else {
                    self.imageButton.setImage(self.tweet.user_image, forState: .Normal)
                }
                
                
                
            }
            
            
            
            
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageButtonPressed(sender: UIButton) {
        
        println("image button pressed")
    }
}
