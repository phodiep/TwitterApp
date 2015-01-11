//
//  User.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/11/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class User {
    let name: String
    let screenName: String
    let ID: String
    let location: String
    let description: String
    let URL: String?
    let imageURL: String
    var followingCount: String?
    var followerCount: String?
    
    let bannerImageURL: String?
    var image: UIImage?
    var bannerImage: UIImage?
    
    init( _ userDictionary: [String: AnyObject]) {
        self.name = userDictionary["name"] as String
        self.screenName = userDictionary["screen_name"] as String
        self.ID = userDictionary["id_str"] as String
        self.location = userDictionary["location"] as String

        if let bannerImageURL = userDictionary["profile_banner_url"] as? String {
            self.bannerImageURL = "\(bannerImageURL)/mobile"
        }

        self.imageURL = userDictionary["profile_image_url"] as String
        
        self.description = userDictionary["description"] as String
        
        let followerCount = userDictionary["followers_count"] as Int
        self.followerCount = "\(followerCount)"

        let followingCount = userDictionary["friends_count"] as Int
        self.followingCount = "\(followingCount)"

        if let entitiesDictionary = userDictionary["entities"] as? [String: AnyObject] {
            if let urlsDictionary = entitiesDictionary["url"] as? [String: AnyObject] {
                if let urlsArray = urlsDictionary["urls"] as? [AnyObject] {
                    self.URL = urlsArray[0]["display_url"] as String?
                }
            }
        }

        
    }
    
}
