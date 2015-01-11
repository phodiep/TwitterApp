//
//  ViewController.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var networkController = NetworkContoller()

    var tweets = [Tweet]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.reloadData()
        
        //dynamic cell height
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // nibName: name of xib file; reuseIdentifier: identifier used for cell
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")

        //fetch home timeline
        self.networkController.fetchHomeTimeline({ (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets!
                self.tableView.reloadData()
            } else {
                println(error)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !self.tweets.isEmpty {
            let sinceID = self.tweets[0].ID as String
            self.networkController.fetchHomeTimeline(sinceID, completionHandler: { (newTweets, error) -> () in
                if error == nil {
                    self.tweets = newTweets! + self.tweets
                    self.tableView.reloadData()
                }
            })
        

        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = self.tweets[indexPath.row]
        
        cell.usernameLabel.text = tweet.user.name
        cell.tweetLabel.text = tweet.text
        cell.screennameLabel.text = "@\(tweet.user.screenName)"
        cell.retweetLabel.text = "\(tweet.retweetCount!) retweets"
        cell.favoriteLabel.text = "\(tweet.favoriteCount!) favorited"

        if tweet.user.image == nil {
            self.networkController.fetchImage(tweet.user.imageURL, completionHandler: { (image) -> () in
                tweet.user.image = image
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            })
        } else {
            cell.imageButton.setImage(tweet.user.image, forState: .Normal)
        }
        
        cell.networkController = self.networkController
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
        
        detailVC.networkController = self.networkController
        detailVC.tweet = self.tweets[indexPath.row]
        
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

