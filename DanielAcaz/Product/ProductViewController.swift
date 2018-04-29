//
//  ProductViewController.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 29/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {

    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    
    var product: Product!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let heightInitial = ivImage.frame.size.height
        ivImage.frame.size.height = 0.0
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseInOut, animations: {
            self.ivImage.frame.size.height = heightInitial
        }, completion: { (success) in
           
        })
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if product != nil {
            tfName.text = product.name
            tfPrice.text = String(product.price)
            
            if let states = product.states {
                tfState.text = states.name
            }
            
            if let image = product.image as? UIImage {
                ivImage.image = image
            }
        }
    
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
