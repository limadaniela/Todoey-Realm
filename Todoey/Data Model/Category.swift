//
//  Category.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-09-06.
//

import Foundation
import RealmSwift

class Category: Object {
    //@objc dynamic makes name a dynamic variable, so we can monitor for changes while the app is running
    @objc dynamic var name: String = ""
    //relationship that specifies that each item can have a number of items 
    let items = List<Item>()
    
}
