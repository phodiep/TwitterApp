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
        
        // nibName: name of xib file; reuseIdentifier: identifier used for cell
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        if tweets.isEmpty {
            self.networkController.fetchUserTimeline(tweetSelected.user_ID, completionHandler: { (tweets, error) -> () in
                
                if error == nil {
                    self.tweets = tweets!
                    let tweet = self.tweets[0]
                    
                    self.usernameLabel.text = tweet.user_name
                    self.screennameLabel.text = "@\(tweet.user_screenName)"
                    self.descriptionLabel.text = tweet.user_description
                    self.locationLabel.text = tweet.user_location
                    self.urlLabel.text = tweet.user_URL
                    self.followingLabel.text = "\(tweet.user_followingCount!) Following"
                    self.followersLabel.text = "\(tweet.user_followerCount!) Followers"
                    
                    //fetch user image if necessary
                    if tweet.user_image == nil {
                        self.networkController.fetchImage(tweet.user_imageURL, completionHandler: { (image) -> () in
                            tweet.user_image = image
                            self.userImage.image = tweet.user_image
                        })
                    } else {
                        self.userImage.image = tweet.user_image!
                    }
                    
                    if tweet.user_bannerImage == nil {
                        if let bannerImageURL = tweet.user_bannerImageURL {
                            self.networkController.fetchImage(tweet.user_bannerImageURL!, completionHandler: { (image) -> () in
                                tweet.user_bannerImage = image
                                self.bannerImage.image = tweet.user_bannerImage
                            })
                        }
                    } else {
                        self.bannerImage.image = tweet.user_bannerImage
                    }
                    
                    
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
            
            
            if tweet.user_image == nil {
                self.networkController.fetchImage(tweet.user_imageURL, completionHandler: { (image) -> () in
                    tweet.user_image = image
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            } else {
                cell.imageButton.setBackgroundImage(tweet.user_image, forState: .Normal)
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
