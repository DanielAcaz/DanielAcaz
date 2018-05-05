//
//  TotalViewController.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 01/05/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    
    @IBOutlet weak var lbTotalValueDolar: UILabel!
    @IBOutlet weak var lbTotalValueReal: UILabel!
    
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        var totalValueDolar: Double = 0.0
        var totalValueReal: Double = 0.0
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let prodcuts = fetchedResultController.fetchedObjects else { return }
        for product in prodcuts {
            totalValueDolar += product.price
            let tax = product.state?.tax ?? 0.0
            var iof = 0.0
            if product.payCard {
                iof = UserDefaults.standard.double(forKey: "iof")
            }
            let dolar = Double(UserDefaults.standard.string(forKey: "dolar")!) ?? 1.0
            totalValueReal += ((1+(iof/100))*(1+(tax/100))*dolar*product.price)
        }
        
        lbTotalValueDolar.text = String(totalValueDolar)
        lbTotalValueReal.text = String(totalValueReal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
