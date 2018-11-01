//
//  Category.swift
//  Todo
//
//  Created by Alessandro on 10/1/18.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}

