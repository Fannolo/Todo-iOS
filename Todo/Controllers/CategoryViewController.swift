//
//  CategoryViewController.swift
//  Todo
//
//  Created by Alessandro on 23/08/2018.
//  Copyright © 2018 Alessandro Fan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let realm = try! Realm()
    
    var preferredFont = UIFont(name: ".SFUIText", size: 33.0)
    
    
    /*temporary variables*/
    private var searchController: UISearchController!
    private var resultsTableController: UITableViewController!
    /*temporary variables*/

    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /*temporary variables*/
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        /*temporary variables*/
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
//        navigationController?.navigationItem.titleView = search.searchBar
//        navigationController?.navigationItem.searchController =  search
//        navigationItem.hidesSearchBarWhenScrolling = false
//        search.dimsBackgroundDuringPresentation = false
    
        loadCategories()
    
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        cell.backgroundColor = RandomFlatColor()
//        cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        cell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.textLabel?.font = preferredFont
        
        
    }
    
    //: MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "NO CATEGORIES ADDED YET"
        
        cell.textLabel?.textColor = HexColor(categoryArray?[indexPath.row].color ?? "#ffffff")
        
        
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
    
    
    //: MARK - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("There was an error while deleting the object at \(indexPath.row), \(error)")
            }
        }
    }
    
    
    //: MARK - Add New Categories
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        textField.keyboardAppearance = .dark
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
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


/*temporary variables*/
extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}



extension CategoryViewController: UISearchControllerDelegate {
    
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

extension CategoryViewController: UISearchResultsUpdating {
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
