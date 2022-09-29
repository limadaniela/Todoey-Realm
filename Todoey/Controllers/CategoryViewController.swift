//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-09-01.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //to initialize a new Realm
    let realm = try! Realm()
    
    //collection of results
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadCategories()

    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //numbers of items in Category
        //if categories is not nil, it will return the number of categories we have
        //if categories is nil, it will just return 1, and tableview will have just one row
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //if not nil we get the Category name
        //if nill, the message will appear
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //performSegue will be triggered when we click on the cells and take us to TodoListViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            //to commit changes to Realm database
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        //to look inside realm and fetch all the objects that belong to the Category data type
        categories = realm.objects(Category.self)
        //to reload tableview with new data
        tableView.reloadData()
    }

    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //when we add a new item by clicking on the Add button, we create an alert that has a textField and an Add button.
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //to happen once the user press "Add" button, to create a new Category and give it a name
            let newCategory = Category()
            newCategory.name = textField.text!
            //to save the new Category to Realm database
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
}
