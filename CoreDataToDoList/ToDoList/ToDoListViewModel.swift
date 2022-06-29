//
//  ToDoListViewModel.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 12/05/2022.
//

import Foundation

final class ToDoListViewModel {
    
    var selectedCategory: Category?
    var onUpdateTable: (() -> Void)?
    
    func shouldUpdateTable() {
        self.onUpdateTable?()
    }
    
    func getItemsCount() -> Int? {
        DataManager.shared.getItemsCount()
    }
    
    func getItems(at index: Int) -> Item? {
        return DataManager.shared.getItems(at: index)
    }
    
    func saveItems() {
        DataManager.shared.saveItems()
        shouldUpdateTable()
    }
    
    func addItem(title: String) {
        guard let selectedCategory = selectedCategory else { return }
        DataManager.shared.addItem(title: title, category: selectedCategory)
        shouldUpdateTable()
    }
    
    func loadItems() {
        guard let selectedCategory = selectedCategory else { return }
        DataManager.shared.loadItems(category: selectedCategory)
        shouldUpdateTable()
    }
    
    func deleteItem(_ item: Item, at index: Int) {
        DataManager.shared.deleteItem(item, at: index)
    }
}
