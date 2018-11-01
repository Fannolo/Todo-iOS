//
//  SwipeTableViewController.swift
//  Todo
//
//  Created by Fan, Alessandro (IT - Milano) on 18/10/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        var keyboardAppearance : UIKeyboardAppearance = .dark
        
        tableView.rowHeight = 80.0
        

    }
    
    
    
    
    //: MARK SwipeTableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell        
        cell.delegate = self
        
        return cell
    }
    
    
    //: MARK - SwipeTableView Delegate Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // handle action by updating model with deletionC
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)

        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    

    
        
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update the data Model
    }

}


