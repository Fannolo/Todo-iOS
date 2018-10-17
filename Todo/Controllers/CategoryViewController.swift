//
//  CategoryViewController.swift
//  Todo
//
//  Created by Alessandro on 23/08/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    
    var categoryArray: Results<Category>?

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        
        loadCategories()
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        cell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //: MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "NO CATEGORIES ADDED YET"
        
        return cell
    }
    
    //: MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //: MARK - Data Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("****Error saving cateogry in context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("************************* Error fecthing categories from context: \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //: MARK - Add New Categories
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
