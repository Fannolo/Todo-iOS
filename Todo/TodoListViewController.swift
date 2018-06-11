//
//  ViewController.swift
//  Todo
//
//  Created by Alessandro on 11/06/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    
    var itemArray = ["Buy Milk", "Buy Burritos", "Make Milk Burritos"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        print(itemArray)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    
    
  
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        let mySelectedCell = tableView.cellForRow(at: indexPath)
        
        if mySelectedCell?.accessoryType == .checkmark {
            mySelectedCell?.accessoryType = .none
        } else {
            mySelectedCell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item Button UIAlert
            
      
            
//            if textField = EMPTY {
//                print("Error")
//            }else{
//                self.itemArray.append(textField.text!)
//            }
            self.itemArray.append(textField.text!)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

