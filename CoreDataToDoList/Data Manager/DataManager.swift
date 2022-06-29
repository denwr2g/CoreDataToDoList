//
//  DataManager.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 11/05/2022.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    var categories = [Category]()
    var items = [Item]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Categories Manipulations Methods
    
    func getCategoriesCount() -> Int? {
        return categories.count
    }
    
    func getCategories(at index: Int) -> Category? {
        return categories[index]
    }
    
    func saveCategories() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func addCategories(title: String) {
        let context = persistentContainer.viewContext
        let newCategory = Category(context: context)
        
        newCategory.name = title
        categories.append(newCategory)
        saveCategories()
    }
        
    func deleteCategory(_ category: Category, at index: Int) {
        let context = persistentContainer.viewContext
        
        context.delete(category)
        categories.remove(at: index)
        
        saveCategories()
    }
    
    //MARK: - ToDo Items Manipulations Methods
    
    func getItemsCount() -> Int? {
        return items.count
    }
    
    func getItems(at index: Int) -> Item? {
        return items[index]
    }
    
    func saveItems() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), category: Category?) {
        
        let context = persistentContainer.viewContext
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        request.predicate = predicate
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    func addItem(title: String, category: Category) {
        let context = persistentContainer.viewContext
        let newItem = Item(context: context)
        
        newItem.title = title
        newItem.done = false
        
        newItem.parentCategory = category
        
        items.append(newItem)
        saveItems()
    }
    
    
    func deleteItem(_ item: Item, at index: Int) {
        let context = persistentContainer.viewContext
        
        context.delete(item)
        items.remove(at: index)
        
        saveItems()
    }
}

//MARK: - TODO:

//func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
//               predicate: NSPredicate? = nil,
//               category: Category? = nil) {
//
//    let context = persistentContainer.viewContext
//    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
//
//    if let additionalPredicate = predicate {
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//    } else {
//        request.predicate = categoryPredicate
//    }
//
//
//    do {
//        items = try context.fetch(request)
//    } catch {
//        print("Error fetching data from context \(error)")
//    }
//
//   // tableView.reloadData()
//}
