//
//  AppDelegate.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-08-18.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Realm initialisation
        do {
            let realm = try Realm()
            } catch {
            print("Error initialising realm, \(error)")
        }
        return true
    }
}

