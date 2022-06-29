//
//  CategoryViewController.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 20/04/2022.
//

import UIKit

class CategoryViewController: UIViewController {
    
    private var tableView = UITableView()
    private var viewModel: CategoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        configNavigationItems()
    }
    
    public func updateTable() {
        tableView.reloadData()
    }
}


//MARK: - CategoryViewController Settings

extension CategoryViewController {
    
    func configTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }
    
    func configure(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
    }
    
    func configNavigationItems() {
        navigationItem.title = "Todoey"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    //MARK: - Add new category
    
    @objc func addButtonPressed() {
        presentAddAlert(withTitle: "Add New Category", message: "", style: .alert) { [weak self] item in
            guard let self = self else { return }
            self.viewModel?.add(title: item)
        }
    }
    
}

//MARK: - TableView Delegate and Datasource


extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.getCategoriesCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryViewCell,
              let category = viewModel?.getCategory(at: indexPath.row) else { return .init() }
        
        cell.categoryName.text = category.name
        
        return cell
    }
   
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = viewModel?.getCategory(at: indexPath.row) else { return }

        viewModel?.shouldGoToToDoListViewController(with: category)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let category = viewModel?.getCategory(at: indexPath.row) else { return }
            
            viewModel?.deleteCategory(category, at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
    }
}





