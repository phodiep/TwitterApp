//
//  ViewController.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets = [Tweet]()
    @IBOutlet var tableView: UITableView!
    var networkController = NetworkContoller()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //dynamic cell height
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // nibName: name of xib file; reuseIdentifier: identifier used for cell
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")

        //fetch home timeline
        if tweets.isEmpty {
            self.networkController.fetchHomeTimeline({ (tweets, error) -> () in
                if error == nil {
                    self.tweets = tweets!
                    self.tableView.reloadData()
                } else {
                    println(error)
                }
            })
        } else {
            self.tableView.reloadData()
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.usernameLabel.text = tweet.user_name
        cell.tweetLabel.text = tweet.text
        cell.screennameLabel.text = "@\(tweet.user_screenName)"
        cell.retweetLabel.text = "\(tweet.retweetCount!) retweets"
        cell.favoriteLabel.text = "\(tweet.favoriteCount!) favorited"

        if tweet.user_image == nil {
            self.networkController.fetchImage(tweet.user_imageURL, completionHandler: { (image) -> () in
                tweet.user_image = image
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        } else {
            cell.imageButton.setImage(tweet.user_image, forState: .Normal)            
        }
        
        cell.networkController = self.networkController
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
        
        detailVC.networkController = self.networkController
        detailVC.tweet = tweets[indexPath.row]
        
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

