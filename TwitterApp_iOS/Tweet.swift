//
//  Tweet.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class Tweet {
    let ID: String
    let text: String
    var retweetCount: String?
    var favoriteCount: String?
    
    var reply_userID: String?
    var reply_tweetID: String?
    var reply_userImageURL: String?
    var reply_userImage: UIImage?

    var retweet_originalTweetID: String?
    var retweet_userID: String?
    var retweet_userImageURL: String?
    var retweet_userImage: UIImage?
    
    let user: User

    init( _ jsonDictionary: [String : AnyObject] ) {

        self.ID = jsonDictionary["id_str"] as String
        self.text = jsonDictionary["text"] as String

        let userDictionary = jsonDictionary["user"] as [String: AnyObject]
        self.user = User(userDictionary)

        let retweetCount = jsonDictionary["retweet_count"] as Int
        self.retweetCount = "\(retweetCount)"
        
        let favoriteCount = jsonDictionary["favorite_count"] as Int
        self.favoriteCount = "\(favoriteCount)"

        if let replyID = jsonDictionary["in_reply_to_user_id_str"] as? String {
            self.reply_userID = "\(replyID)"
            self.reply_tweetID = jsonDictionary["in_reply_to_status_id_str"] as? String
        }
        
        if let retweetStatus = jsonDictionary["retweeted_status"] as? [String: AnyObject] {
            if let retweetUser = retweetStatus["user"] as? [String: AnyObject] {
                self.retweet_userID = retweetUser["id_str"] as String?
                self.retweet_userImageURL = retweetUser["profile_image_url"] as String?
                self.retweet_originalTweetID = retweetStatus["id_str"] as String?
            }
        }
        
        
    }
    
    func updateWithInfo(jsonDictionary: [String: AnyObject]) {
        let retweetCount = jsonDictionary["retweet_count"] as Int
        self.retweetCount = "\(retweetCount)"
        
        let favoriteCount = jsonDictionary["favorite_count"] as Int
        self.favoriteCount = "\(favoriteCount)"
        
        
    }
    

}