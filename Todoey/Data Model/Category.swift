//
//  Category.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-09-06.
//

import Foundation
import RealmSwift

class Category: Object {
    //to use Realm, need to mark variables with @objc dynamic
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
