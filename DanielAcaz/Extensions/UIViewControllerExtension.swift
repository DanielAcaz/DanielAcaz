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
}

