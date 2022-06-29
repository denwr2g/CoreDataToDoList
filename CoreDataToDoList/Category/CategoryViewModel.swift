//
//  CategoryViewModel.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 20/04/2022.
//

import Foundation

final class CategoryViewModel {
    
    var onGoToToDoListViewController: ((Category) -> Void)?
    var onUpdateTable: (() -> Void)?
    
    init() {
        load()
    }
    
    func shouldGoToToDoListViewController(with category: Category) {
        self.onGoToToDoListViewController?(category)
    }
    
    func shouldUpdateTable() {
        self.onUpdateTable?()
    }
    
    func getCategoriesCount() -> Int? {
        DataManager.shared.getCategoriesCount()
    }
    
    func getCategory(at index: Int) -> Category? {
        DataManager.shared.getCategories(at: index)
    }
    
    func load() {
        DataManager.shared.loadCategories()
        shouldUpdateTable()
    }
    
    func saver() {
        DataManager.shared.saveCategories()
        shouldUpdateTable()
    }
    
    func add(title: String) {
        DataManager.shared.addCategories(title: title)
        shouldUpdateTable()
    }
    
    func deleteCategory(_ category: Category, at index: Int) {
        DataManager.shared.deleteCategory(category, at: index)
    }
    
}
