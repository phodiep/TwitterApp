//
//  UserViewController.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var networkController: NetworkContoller!
    var tweetSelected: Tweet!
    var tweets = [Tweet]()
    
    var refreshControl: UIRefreshControl!

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.grayColor()
        self.refreshControl.addTarget(self, action: Selector("refreshTweets"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        // nibName: name of xib file; reuseIdentifier: identifier used for cell
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        self.networkController.fetchUserTimeline(tweetSelected.user.ID, completionHandler: { (tweets, error) -> () in
            
            if error == nil {
                self.tweets = tweets!
                let tweet = self.tweets[0]
                
                self.usernameLabel.text = tweet.user.name
                self.screennameLabel.text = "@\(tweet.user.screenName)"
                self.descriptionLabel.text = tweet.user.description
                self.locationLabel.text = tweet.user.location
                self.urlLabel.text = tweet.user.URL
                self.followingLabel.text = "\(tweet.user.followingCount!) Following"
                self.followersLabel.text = "\(tweet.user.followerCount!) Followers"
                
                //fetch user image if necessary
                if tweet.user.image == nil {
                    self.networkController.fetchImage(tweet.user.imageURL, completionHandler: { (image) -> () in
                        tweet.user.image = image
                        self.userImage.image = tweet.user.image
                    })
                } else {
                    self.userImage.image = tweet.user.image!
                }
                
                if tweet.user.bannerImage == nil {
                    if let bannerImageURL = tweet.user.bannerImageURL {
                        self.networkController.fetchImage(tweet.user.bannerImageURL!, completionHandler: { (image) -> () in
                            tweet.user.bannerImage = image
                            self.bannerImage.image = tweet.user.bannerImage
                        })
                    }
                } else {
                    self.bannerImage.image = tweet.user.bannerImage
                }
                
                
                self.tableView.reloadData()
            } else {
                println(error)
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshTweets()
    }
    
    func refreshTweets() {
        
        var sinceID: String?
        let userID = tweetSelected.user.ID as String
        if !tweets.isEmpty {
            sinceID = tweetSelected.ID as String
        } else {
            sinceID = nil
        }
        
        self.networkController.fetchUserTimeline(userID, sinceID: sinceID) { (newTweets, error) -> () in
            if error == nil {
                self.tweets = newTweets! + self.tweets
                self.tableView.reloadData()
            }
        }
        self.refreshControl.endRefreshing()
    }

    func loadOlderTweets() {
        if !self.tweets.isEmpty {
            let maxID = self.tweets.last!.ID as String
            self.networkController.fetchHomeTimelineOlderTweets(maxID, completionHandler: { (newTweets, error) -> () in
                if error == nil {
                    self.tweets += newTweets!
                    self.tableView.reloadData()
                }
            })
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row >= tweets.count - 1) {
            loadOlderTweets()
//            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.usernameLabel.text = tweet.user.name
        cell.tweetLabel.text = tweet.text
        cell.screennameLabel.text = "@\(tweet.user.screenName)"
        cell.retweetLabel.text = "\(tweet.retweetCount!) retweets"
        cell.favoriteLabel.text = "\(tweet.favoriteCount!) favorited"
        
        if tweet.reply_userID != nil {
            if tweet.reply_userImage == nil {
                self.networkController.fetchUser(tweet.reply_userID!, completionHandler: { (userDictionary, error) -> () in
                    if error == nil {
                        
                        tweet.reply_userImageURL = userDictionary!["profile_image_url"] as? String
                        self.networkController.fetchImage(tweet.reply_userImageURL!, completionHandler: { (image) -> () in
                            tweet.reply_userImage = image as UIImage!
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
                        )
                    }
                    
                })
            } else {
                cell.imageButton.setBackgroundImage(tweet.reply_userImage, forState: .Normal)
            }
        } else if tweet.retweet_userID != nil {
            if tweet.retweet_userImage == nil {
                self.networkController.fetchImage(tweet.retweet_userImageURL!, completionHandler: { (image) -> () in
                    tweet.retweet_userImage = image as UIImage!
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            } else {
                cell.imageButton.setBackgroundImage(tweet.retweet_userImage, forState: .Normal)
            }
        } else {
            
            
            if tweet.user.image == nil {
                self.networkController.fetchImage(tweet.user.imageURL, completionHandler: { (image) -> () in
                    tweet.user.image = image
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            } else {
                cell.imageButton.setBackgroundImage(tweet.user.image, forState: .Normal)
            }
        }
    
    
        cell.networkController = self.networkController
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tweet: Tweet?

        if self.tweets[indexPath.row].reply_tweetID != nil {
            self.networkController.fetchTweet(self.tweets[indexPath.row].reply_tweetID!, completionHandler: { (jsonDictionary, error) -> () in
                if error == nil {
                    tweet = Tweet(jsonDictionary!)
                    let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
                    detailVC.networkController = self.networkController
                    detailVC.tweet = tweet!
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
        } else if self.tweets[indexPath.row].retweet_originalTweetID != nil {
            self.networkController.fetchTweet(self.tweets[indexPath.row].retweet_originalTweetID!, completionHandler: { (jsonDictionary, error) -> () in
                if error == nil {
                    tweet = Tweet(jsonDictionary!)
                    let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
                    detailVC.networkController = self.networkController
                    detailVC.tweet = tweet!
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
        } else {
            let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DETAIL_VC") as DetailViewController
            detailVC.networkController = self.networkController
            detailVC.tweet = self.tweets[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    

}
