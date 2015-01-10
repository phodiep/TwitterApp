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
    let retweetCount: String?
    var favoriteCount: String?
    
    let user_name: String
    let user_screenName: String
    let user_ID: String
    let user_location: String
    let user_URL: String?
    let user_imageURL: String
    let user_followingCount: String?
    let user_followerCount: String?
    var user_bannerImageURL: String?
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

        self.user_imageURL = userDictionary["profile_image_url"] as String
        
        let followerCount = userDictionary["followers_count"] as Int
        self.user_followerCount = "\(followerCount)"
        
        let followingCount = userDictionary["friends_count"] as Int
        self.user_followingCount = "\(followingCount)"

        let retweetCount = jsonDictionary["retweet_count"] as Int
        self.retweetCount = "\(retweetCount)"

        let entities = userDictionary["entities"] as [String: AnyObject]
        let urls = entities["url"] as [String: AnyObject]
        let urlsArray = urls["urls"] as [AnyObject]
        self.user_URL = urlsArray[0]["display_url"] as String?

    }

}