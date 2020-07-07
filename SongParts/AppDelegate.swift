 //
//  AppDelegate.swift
//  SongParts
//
//  Created by Lucas Ference on 5/31/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import AWSS3
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        initializeS3()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /*
     Following guide detailed here:
     https://medium.com/@iamayushverma/uploading-photos-videos-files-to-aws-s3-using-swift-4-1241f690a993
     */
    func initializeS3() {
        
        // LMAO this works in getting the poolID out of this.
        // there must be a better way
        /*
         let credProvider = (Bundle.main.object(forInfoDictionaryKey: "AWS") as? Dictionary<String, AnyObject>)?["CredentialsProvider"]
         let cognitoIdentity = (credProvider as? Dictionary<String, AnyObject>)?["CognitoIdentity"]
         let def = (cognitoIdentity as? Dictionary<String, AnyObject>)?["Default"]
         let poolId = (def as? Dictionary<String, AnyObject>)?["PoolId"] as? String
         
         if let id = poolId {
             print(id)
         }
         */
        
        // Hard code it for now
        let poolId = "us-east-1:e042182a-7b19-4623-84f3-a28d41f71de5"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast1,
            identityPoolId: poolId
        )
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }


}

