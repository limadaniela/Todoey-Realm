//
//  ViewController.swift
//  Todoey
//
//  Created by Daniela Lima on 2022-08-18.
//

import UIKit
import RealmSwift
import SwipeCellKit
 
//As we've inherited UITableVIewController and added a tableViewController to the storyboard instead of a normal ViewController,
//we don't need to keep ViewController as a subclass of UIViewController, and link up any @IBOutlet or add the whole self.tableView.delegate to set ourselves as the delegate or data source,
//because all of is automated behind the scenes by XCode
//SwipeTableViewController inherits UITableViewController
class TodoListViewController: SwipeTableViewController {
    
    //colection of results of Item objects
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            //loads up all the to-do list items from database.
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //file path to Documents folder where items inckuded in to-do will be saved
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView Datasource Methods
    
    //to specify how many rows we wanted in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //to specify what cells should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusable cell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //if todoItems is not nil, then grab the item at indexPath.row
        //if todoItems is nil, shows a message
        if let item = todoItems?[indexPath.row] {
            
            //label for every single cell
            cell.textLabel?.text = item.title
            
            //to add or remove a checkmark on selected cell
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //to detect which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //to update data using Realm
        //to delete data using Realm, replace item.done = !item.done with realm.delete(item)
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //when selected, cell flashes gray and goes back to being deselected and white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    //button to add new items to to-do list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //this textField has the scope of the entire addButtonPressed IBAction
        //and it's accessible inside alert closures
        var textField = UITextField()
        
        //when addButton is pressed, it will display a pop-up with a text field
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //button to press after finish writing
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //to unwrap self.selectedCategory
            if let currentCategory = self.selectedCategory {
                do {
                    //inside closure need to use self
                    try self.realm.write {
                        //to create a new item
                        let newItem = Item()
                        //to give the new item a title
                        newItem.title = textField.text!
                        //to stamp every new item with the current date and time
                        newItem.dateCreated = Date()
                        //to append new item to items in the current category
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            //reload tableView with all the new data 
            self.tableView.reloadData()
            
        }
        //to add action to alert
        alert.addAction(action)
        //to include a textField to pop-up alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //to show alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        //Items will be sorted by their title and listed in alphabetical order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    
    }
}

//MARK: - Search Bar Methods

//        set viewController as the delegate for searchBar, so whenever there's changes in searchBar this is the class that's gonna to be informed
extension TodoListViewController: UISearchBarDelegate {
    //method will be triggered when the user press the searchBar button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //to filter do-do list items
        //cd makes the query insensitive for case and diacritic
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    //to go back to original list of all items when clear/dismiss searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //to dismiss keyboard and cursor, when clearing searchBar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

    

