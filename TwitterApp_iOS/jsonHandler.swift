//
//  jsonHandler.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

func serializeJson_multipleTweets(jsonData: NSData) -> [ [String:AnyObject] ]? {
    // serializes json data into array of dictionaries
    return NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [ [String:AnyObject] ]
}

func serializeJson_singleTweet(jsonData: NSData) -> [String : AnyObject]? {
    // serializes json data into a single dictionary
    return NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String : AnyObject]
}

func parseJsonForTweets(jsonArray: [ [String: AnyObject]]) -> [Tweet] {
    // parse json array of dictionaries for tweets
    var tweets = [Tweet]()
    for object in jsonArray {
        tweets.append(Tweet(object))
    }
    return tweets
}