//
//  TestingViewController.swift
//  Todo
//
//  Created by Fan, Alessandro (IT - Milano) on 07/11/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import Foundation
import UIKit


class TestingViewController : UIViewController{

    @IBOutlet weak var categoryTitle: UILabel!

    override func viewDidLoad() {
        
        categoryTitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        categoryTitle.adjustsFontSizeToFitWidth = true
        categoryTitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
   
    }
    
}
