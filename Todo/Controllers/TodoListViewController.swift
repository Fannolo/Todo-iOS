//
//  ViewController.swift
//  Todo
//
//  Created by Alessandro on 11/06/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var red: UIColor = (UIColor(hexString: "#EB436A")) ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var todoItems: Results<Item>?
    
    /*temporary variables*/
    private var searchController: UISearchController!
    
    private var resultsTableController: UITableViewController!
    /*temporary variables*/
    
    let realm = try! Realm()
    var preferredFont = UIFont(name: ".SFUIText", size: 23.0)


    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*temporary variables*/
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        /*temporary variables*/

        
        searchBar.keyboardAppearance = .dark
        searchBar.placeholder = "Search"
//        navigationBar.titleView = searchBar
//        navigationBar.title = selectedCategory?.name
        
        
//        navigationController?.navigationBar.barTintColor = UIColor(hexString: selectedCategory?.color ?? "ffffff")
       
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.textLabel?.textColor = UIColor(hexString: "ffffff")
        cell.textLabel?.font = preferredFont
        
    }
    
    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = HexColor(selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        // Ternary operator ==>
        // value condition ? valueIfTrue : valueIfFalse
        // set the cell accessory type if item.done == true to checkmark else to none
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: - How to delete items
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("There was an error while deleting the object at \(indexPath.row), \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("********** Error saving cateogry in context: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            textField.keyboardAppearance = .dark
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Model Manupulation Methodsl
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
}

//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.keyboardAppearance = .dark
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//
//        tableView.reloadData()
//    }
//
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//
//}


/*temporary variables*/
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}



extension TodoListViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
}


//    private func findMatches(searchString: String) -> NSCompoundPredicate {
//        /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
//         Example if searchItems contains "Gladiolus 51.99 2001":
//         name CONTAINS[c] "gladiolus"
//         name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
//         name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
//         */
//        var searchItemsPredicate = [NSPredicate]()
//
//        /** Below we use NSExpression represent expressions in our predicates.
//         NSPredicate is made up of smaller, atomic parts:
//         two NSExpressions (a left-hand value and a right-hand value).
//         */
//
//        // Name field matching.
//        let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
//        let searchStringExpression = NSExpression(forConstantValue: searchString)
//
//        let titleSearchComparisonPredicate =
//            NSComparisonPredicate(leftExpression: titleExpression,
//                                  rightExpression: searchStringExpression,
//                                  modifier: .direct,
//                                  type: .contains,
//                                  options: [.caseInsensitive, .diacriticInsensitive])
//
//        searchItemsPredicate.append(titleSearchComparisonPredicate)
//
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .none
//        numberFormatter.formatterBehavior = .default
//
//        // The `searchString` may fail to convert to a number.
//        if let targetNumber = numberFormatter.number(from: searchString) {
//            // Use `targetNumberExpression` in both the following predicates.
//            let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
//
//            // The `yearIntroduced` field matching.
//            let yearIntroducedExpression = NSExpression(forKeyPath: ExpressionKeys.yearIntroduced.rawValue)
//            let yearIntroducedPredicate =
//                NSComparisonPredicate(leftExpression: yearIntroducedExpression,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(yearIntroducedPredicate)
//
//            // The `price` field matching.
//            let lhs = NSExpression(forKeyPath: ExpressionKeys.introPrice.rawValue)
//
//            let finalPredicate =
//                NSComparisonPredicate(leftExpression: lhs,
//                                      rightExpression: targetNumberExpression,
//                                      modifier: .direct,
//                                      type: .equalTo,
//                                      options: [.caseInsensitive, .diacriticInsensitive])
//
//            searchItemsPredicate.append(finalPredicate)
//        }
//
//        let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
//
//        return orMatchPredicate
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        // Update the filtered array based on the search text.
//        let searchResults = products
//
//        // Strip out all the leading and trailing spaces.
//        let whitespaceCharacterSet = CharacterSet.whitespaces
//        let strippedString =
//            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
//        let searchItems = strippedString.components(separatedBy: " ") as [String]
//
//        // Build all the "AND" expressions for each value in searchString.
//        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
//            findMatches(searchString: searchString)
//        }
//
//        // Match up the fields of the Product object.
//        let finalCompoundPredicate =
//            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
//
//        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
//
//        // Apply the filtered results to the search results table.
//        if let resultsController = searchController.searchResultsController as? ResultsTableController {
//            resultsController.filteredProducts = filteredResults
//            resultsController.tableView.reloadData()
//        }
//    }
/*temporary variables*/
}
