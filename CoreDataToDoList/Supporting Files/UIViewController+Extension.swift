//
//  UIViewController+Extension.swift
//  CoreDataToDoList
//
//  Created by deniss.lobacs on 20/04/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAddAlert(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addTextField { textField in
            textField.placeholder = "Type name.."
        }
        let search = UIAlertAction(title: "Add", style: .default) { action in
            let textField = alert.textFields?.first
            guard let title = textField?.text else { return }
            if !title.isEmpty {
              //  let title = title.split(separator: " ").joined(separator: "%20")
                completionHandler(title)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(search)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
