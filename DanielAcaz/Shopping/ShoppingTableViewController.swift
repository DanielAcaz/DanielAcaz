//
//  ShoppingTableViewController.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 29/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    var labelEmptyList = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        labelEmptyList.text = "Sua Lista está vazia!"
        labelEmptyList.textAlignment = .center
        labelEmptyList.textColor = .black
        
        listShoppings()
        
    }

    // MARK: - Override Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? labelEmptyList : nil
            tableView.separatorStyle = (count == 0) ? UITableViewCellSeparatorStyle.none : UITableViewCellSeparatorStyle.singleLine
            return count
        } else {
            tableView.backgroundView = labelEmptyList
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none 
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as! ShoppingTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.lbName.text = product.name
        cell.lbPrice.text = product.price.toCurrencyString(forLocale: .EN, useSymbol: true)
        if let image = product.image as? UIImage {
            cell.ivImage.image = image
        } else {
            cell.ivImage.image = nil
        }
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            context.delete(product)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ProductViewController {
            if let index = tableView.indexPathForSelectedRow {
                viewController.product = fetchedResultController.object(at: index)
            } else {
                viewController.product = nil
            }
        }
    }
    //MARK: - My Methods
    func listShoppings(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension ShoppingTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
