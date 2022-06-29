//
//  ViewController.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 20/04/2022.
//

import UIKit
import SnapKit
import CoreData

class ToDoListViewController: UIViewController {
    
    var viewModel: ToDoListViewModel?
    private var tableView = UITableView()
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadItems()
        
        configTable()
        configSearchController()
        configNavigationItems()
    }
       
}


//MARK: - CategoryViewController Settings

extension ToDoListViewController {
    
    func configTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoListViewCell", bundle: nil), forCellReuseIdentifier: "toDoListCell")
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func configSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.delegate = self
        
    }
    
    func configNavigationItems() {
        navigationItem.title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    public func updateTable() {
        tableView.reloadData()
    }
    
    func configure(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Add new item
    
    @objc func addButtonPressed() {
        presentAddAlert(withTitle: "Add New Category", message: "", style: .alert) { [weak self] item in
            guard let self = self else { return }
            
            self.viewModel?.addItem(title: item)
        }
    }
        
    
}

//MARK: - TableView Delegate and Datasource


extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.getItemsCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell", for: indexPath) as? ToDoListViewCell,
              let item = viewModel?.getItems(at: indexPath.row) else {return .init()}
                
        cell.titleName.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        guard let item = viewModel?.getItems(at: indexPath.row) else { return }
        
        item.done = !item.done
        viewModel?.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let item = viewModel?.getItems(at: indexPath.row) else { return }
            
            viewModel?.deleteItem(item, at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
    }
}



//MARK: - SearchBar Methods TODO:

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //   loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            //            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}

extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            //  loadItems()
        }
    }
    
    
}



