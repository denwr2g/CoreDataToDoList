//
//  AppDelegate.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 20/04/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setupNavigationController()
        window?.rootViewController = navigationController

        return true
    }
    
    
    func makeCategoryViewController() -> UIViewController {
        let vc = CategoryViewController()
        let viewModel = CategoryViewModel()
        
        viewModel.onGoToToDoListViewController = { [weak self] category in
            guard let self = self else { return }
            self.navigationController?.pushViewController(self.makeToDoListViewController(category: category), animated: true)
        }
        
        viewModel.onUpdateTable = {
            vc.updateTable()
        }
        
        vc.configure(viewModel: viewModel)
        
        return vc
    }
    
    func makeToDoListViewController(category: Category) -> UIViewController {
        let vc = ToDoListViewController()
        let vm = ToDoListViewModel()
        
        vm.onUpdateTable = {
            vc.updateTable()
        }
        
        vm.selectedCategory = category
        vc.configure(viewModel: vm)
        
        
        return vc
    }
    
    func setupNavigationController() {
        navigationController = UINavigationController(rootViewController: makeCategoryViewController())
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.shared.saveContext()
    }

}

