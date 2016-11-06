//
//  AppDelegate.swift
//  MeMe
//
//  Created by Alexander on 10/1/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var memes = [Meme]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Loads a set of test data
        //loadTestData()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func loadTestData(){
        memes.append(Meme(textTop: "Top Text For Image 1",
                          textBottom: "Bottom Text For Image 1",
                          imageOriginal: #imageLiteral(resourceName: "image 1"), imageMemed: #imageLiteral(resourceName: "image 1")))
        memes.append(Meme(textTop: "Top Text For Image 2",
                          textBottom: "Bottom Text For Image 2",
                          imageOriginal: #imageLiteral(resourceName: "image 2"), imageMemed: #imageLiteral(resourceName: "image 2")))
        memes.append(Meme(textTop: "Top Text For Image 3",
                          textBottom: "Bottom Text For Image 3",
                          imageOriginal: #imageLiteral(resourceName: "image 3"), imageMemed: #imageLiteral(resourceName: "image 3")))
        memes.append(Meme(textTop: "Top Text For Image 4",
                          textBottom: "Bottom Text For Image 4",
                          imageOriginal: #imageLiteral(resourceName: "image 4"), imageMemed: #imageLiteral(resourceName: "image 4")))
        memes.append(Meme(textTop: "Top Text For Image 5",
                          textBottom: "Bottom Text For Image 5",
                          imageOriginal: #imageLiteral(resourceName: "image 5"), imageMemed: #imageLiteral(resourceName: "image 5")))
        memes.append(Meme(textTop: "Top Text For Image 6",
                          textBottom: "Bottom Text For Image 6",
                          imageOriginal: #imageLiteral(resourceName: "image 6"), imageMemed: #imageLiteral(resourceName: "image 6")))
        memes.append(Meme(textTop: "Top Text For Image 7",
                          textBottom: "Bottom Text For Image 7",
                          imageOriginal: #imageLiteral(resourceName: "image 7"), imageMemed: #imageLiteral(resourceName: "image 7")))
        memes.append(Meme(textTop: "Top Text For Image 8",
                          textBottom: "Bottom Text For Image 8",
                          imageOriginal: #imageLiteral(resourceName: "image 8"), imageMemed: #imageLiteral(resourceName: "image 8")))
        memes.append(Meme(textTop: "Top Text For Image 9",
                          textBottom: "Bottom Text For Image 9",
                          imageOriginal: #imageLiteral(resourceName: "image 9"), imageMemed: #imageLiteral(resourceName: "image 9")))
        memes.append(Meme(textTop: "Top Text For Image 10",
                          textBottom: "Bottom Text For Image 10",
                          imageOriginal: #imageLiteral(resourceName: "image 10"), imageMemed: #imageLiteral(resourceName: "image 10")))
        memes.append(Meme(textTop: "Top Text For Image 11",
                          textBottom: "Bottom Text For Image 11",
                          imageOriginal: #imageLiteral(resourceName: "image 11"), imageMemed: #imageLiteral(resourceName: "image 11")))
    }

}

