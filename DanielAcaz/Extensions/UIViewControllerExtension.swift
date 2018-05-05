//
//  UIViewControllerExtension.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 29/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func numberValidation(_ textNumber: UITextField) -> Double {
        if let number = Double(textNumber.text!) {
            return number
        } else {
            textNumber.text = ""
            let alert = UIAlertController(title: "Numero Inválido", message: "Por favor, preencha com um valor válido", preferredStyle: .alert)
            present(alert, animated: true, completion: {sleep(1)})
            alert.dismiss(animated: true, completion: nil)
            return 0.0
        }
    }
}

