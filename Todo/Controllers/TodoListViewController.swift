//
//  ViewController.swift
//  Todo
//
//  Created by Alessandro on 11/06/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    
    var itemArray = [Item]()
    
    

    
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        let newItem = Item()
        newItem.title = "Find Mike"
        newItem.done = true
        
        let newItem2 = Item()
        newItem2.title = "Find Milk"
        newItem2.done = false
        
        itemArray.append(newItem)
        itemArray.append(newItem2)
        
        
        
        tableView.separatorStyle = .none
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }

        
    }
    
    
    //MARK: - Table View Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value condition ? valueIfTrue : valueIfFalse
        // set the cell accessory type if item.done == true to checkmark else to none
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item Button UIAlert
            
            let newNewItem = Item()
            newNewItem.title = textField.text!
            
            self.itemArray.append(newNewItem)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
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
