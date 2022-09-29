//
//  Item.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-09-06.
//

import Foundation
import RealmSwift

class Item: Object {
    //when declaring non-generic properties, use @objc dynamic var anotation
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //in Realm the inverse relationship is not defined automatically.
    //LinkingObjects is used to define the inverse relationship that links each item back to a parentCategory
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
