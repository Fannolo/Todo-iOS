//
//  Item.swift
//  Todo
//
//  Created by Alessandro on 11/06/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import Foundation


class Item : Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
