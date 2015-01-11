//
//  NetworkController.swift
//  TwitterApp_iOS
//
//  Created by Pho Diep on 1/9/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkContoller {
    
    var twitterAccount: ACAccount?
    let twitterMainURL = "https://api.twitter.com/1.1/"
    var imageQueue = NSOperationQueue()
    
    
    init() {
        
    }
    
    func fetchFromURL(url: String) -> SLRequest? {
        // create URL, create request, sign request, return request
        let requestURL = NSURL(string: url)
        let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
        twitterRequest.account = self.twitterAccount
        return twitterRequest
    }
    

    func fetchHomeTimeline(completionHandler: ([Tweet]?, String?) -> () ) {
        // confirm account access, fetch response from url, if successful populate tweets array, else return error
        let hometimelineURL = "\(self.twitterMainURL)statuses/home_timeline.json"
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (accessGranted, errorString) -> Void in
            
            if !accessGranted {
                completionHandler(nil, "Access not granted")
            } else {
                let accounts = accountStore.accountsWithAccountType(accountType)
                if accounts.isEmpty {
                    completionHandler(nil, "No accounts found")
                } else {
                    self.twitterAccount = accounts.first as ACAccount!

                    if let twitterRequest = self.fetchFromURL(hometimelineURL) {
                        var tweets = [Tweet]()
                        var errorString: String?
                        
                        twitterRequest.performRequestWithHandler({ (jsonData, URLResponse, error) -> Void in
                            
                            switch URLResponse.statusCode {
                            case 200...299:
                                let jsonArray = serializeJson_multipleTweets(jsonData)
                                tweets = parseJsonForTweets(jsonArray!)
                            case 300...599:
                                errorString = "\(String(URLResponse.statusCode)) error ... \(error)"
                            default:
                                errorString = "default case"
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                completionHandler(tweets, errorString)
                            })
                        })
                    }
                }
            }
        }
    }
    
    
    func fetchTweet(tweet: Tweet, completionHandler: ( [String: AnyObject]?, String?) -> () ) {
        // fetch response from url, if successful return jsonDictionary, else return error
        let tweetURL = "\(self.twitterMainURL)statuses/show.json?id=\(tweet.ID)"
        
        if let twitterRequest = self.fetchFromURL(tweetURL) {
            twitterRequest.performRequestWithHandler({ (jsonData, URLResponse, error) -> Void in
                var errorString: String?
                var jsonDictionary: [String: AnyObject]?

                switch URLResponse.statusCode {
                case 200...299:
                    jsonDictionary = serializeJson_singleTweet(jsonData)
                case 300...599:
                    errorString = "\(String(URLResponse.statusCode)) error ... \(error)"
                default:
                    errorString = "default case"
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(jsonDictionary, errorString)
                })
            })
        }
    }
    
    
    func fetchImage(tweet: Tweet, completionHandler: (UIImage?) -> () ) {

        if let imageURL = NSURL(string: tweet.user_imageURL) {
            self.imageQueue.addOperationWithBlock({ () -> Void in
                if let imageData = NSData(contentsOfURL: imageURL) {
                    let image = UIImage(data: imageData)
                    tweet.user_image = image
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image)
                    })
                }
            })
        }
    }

    func fetchBannerImage(tweet: Tweet, completionHandler: (UIImage?) -> () ) {
        
        if let imageURL = NSURL(string: tweet.user_bannerImageURL) {
            self.imageQueue.addOperationWithBlock({ () -> Void in
                if let imageData = NSData(contentsOfURL: imageURL) {
                    let image = UIImage(data: imageData)
                    tweet.user_image = image
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(image)
                    })
                }
            })
        }
    }

    
    func fetchUserTimeline(tweet: Tweet, completionHandler: ([Tweet]?, String?) -> () ) {
        let userTimelineURL = "\(self.twitterMainURL)statuses/user_timeline.json?user_id=\(tweet.user_ID)"
        
        if let twitterRequest = self.fetchFromURL(userTimelineURL) {
            twitterRequest.performRequestWithHandler({ (jsonData, URLResponse, error) -> Void in
                var tweets: [Tweet]?
                var errorString: String?
                
                switch URLResponse.statusCode {
                case 200...299:
                    let jsonArray = serializeJson_multipleTweets(jsonData)
                    tweets = parseJsonForTweets(jsonArray!)
                case 300...599:
                    errorString = "\(String(URLResponse.statusCode)) error ... \(error)"
                default:
                    errorString = "default case"
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(tweets, errorString)
                })
            })
        }
    }
    
}











