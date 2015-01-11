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
                
                self.usernameLabel.text = self.tweet.user.name
                self.tweetLabel.text = self.tweet.text
                self.screennameLabel.text = "@\(self.tweet.user.screenName)"
                self.retweetLabel.text = "\(self.tweet.retweetCount!) retweets"
                self.favoriteLabel.text = "\(self.tweet.favoriteCount!) favorited"

                if self.tweet.user.image == nil {
                    self.networkController.fetchImage(self.tweet.user.imageURL, completionHandler: { (image) -> () in
                        self.tweet.user.image = image
                        self.imageButton.setImage(self.tweet.user.image, forState: .Normal)
                    })
                } else {
                    self.imageButton.setImage(self.tweet.user.image, forState: .Normal)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func imageButtonPressed(sender: UIButton) {
        
        let userVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_VC") as UserViewController
        
        userVC.networkController = self.networkController
        userVC.tweetSelected = self.tweet
        
        self.navigationController?.pushViewController(userVC, animated: true)

        
        
    }
}
