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
    var replyToUserID: String?
    var retweeted: Bool?
    
    let user_name: String
    let user_screenName: String
    let user_ID: String
    let user_location: String
    let user_description: String
    let user_URL: String?
    let user_imageURL: String
    var user_followingCount: String?
    var user_followerCount: String?

    let user_bannerImageURL: String
    var user_image: UIImage?
    var user_bannerImage: UIImage?


    init( _ jsonDictionary: [String : AnyObject] ) {

        self.ID = jsonDictionary["id_str"] as String
        self.text = jsonDictionary["text"] as String

        let userDictionary = jsonDictionary["user"] as [String: AnyObject]
        self.user_name = userDictionary["name"] as String
        self.user_screenName = userDictionary["screen_name"] as String
        self.user_ID = userDictionary["id_str"] as String
        self.user_location = userDictionary["location"] as String
        
        let bannerImageURL = userDictionary["profile_banner_url"] as String
        self.user_bannerImageURL = "\(bannerImageURL)/mobile"

        self.user_imageURL = userDictionary["profile_image_url"] as String
        
        self.user_description = userDictionary["description"] as String
        
        let followerCount = userDictionary["followers_count"] as Int
        self.user_followerCount = "\(followerCount)"
        
        let followingCount = userDictionary["friends_count"] as Int
        self.user_followingCount = "\(followingCount)"

        let retweetCount = jsonDictionary["retweet_count"] as Int
        self.retweetCount = "\(retweetCount)"
        
        let favoriteCount = jsonDictionary["favorite_count"] as Int
        self.favoriteCount = "\(favoriteCount)"

        if let entitiesDictionary = userDictionary["entities"] as? [String: AnyObject] {
            if let urlsDictionary = entitiesDictionary["url"] as? [String: AnyObject] {
                if let urlsArray = urlsDictionary["urls"] as? [AnyObject] {
                    self.user_URL = urlsArray[0]["display_url"] as String?
                }
            }
        }
        
        if let replyID = jsonDictionary["in_reply_to_status_id_str"] as? Int {
            self.replyToUserID = "\(replyID)"
        }
        
//        if let retweetStatus = jsonDictionary["retweeted_status"] as? [String: AnyObject] {
//            
//            print(retweetStatus["user"])
//        } else {
//            println("-")
//        }
        
        
    }
    
    func updateWithInfo(jsonDictionary: [String: AnyObject]) {
        let retweetCount = jsonDictionary["retweet_count"] as Int
        self.retweetCount = "\(retweetCount)"
        
        let favoriteCount = jsonDictionary["favorite_count"] as Int
        self.favoriteCount = "\(favoriteCount)"
        
        
    }
    

}