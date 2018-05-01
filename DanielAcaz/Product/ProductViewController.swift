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
    var miniImage: UIImage!
    var pickerView: UIPickerView!
    var fetchedResultController: NSFetchedResultsController<State>!
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let heightInitial = ivImage.frame.size.height
        ivImage.frame.size.height = 0.0
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseInOut, animations: {
            self.ivImage.frame.size.height = heightInitial
        }, completion: { (success) in
           
        })
        
        loadStates()
        createPickerView()
        
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

    //MARK - IBActions

    @IBAction func btImageAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Escolher Imagem", message: "Onde está a imagem do produto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btSaveProductAction(_ sender: Any) {
        if product == nil {
            product = Product(context: context)
        }
        
        product.name = tfName.text
        product.price = Double(tfPrice.text!)!
        product.states?.name = tfState.text
        if miniImage != nil {
            product.image = miniImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: My Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func createPickerView() {
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        tfState.inputView = pickerView
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        tfState.inputAccessoryView = toolbar
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }

    @objc func done() {
        let indexPath = IndexPath(row: pickerView.selectedRow(inComponent: 0), section: 0)
        tfState.text = fetchedResultController.object(at: indexPath).name
        UserDefaults.standard.set(tfState.text!, forKey: "genre")
        cancel()
        
    }
    
    func loadStates() {
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
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

// MARK: - Extensions
extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        miniImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivImage.image = miniImage

        dismiss(animated: true, completion: nil)
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
    }
}

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexPath = IndexPath(row: row, section: 0)
        let product = fetchedResultController.object(at: indexPath)
        return product.name
    }
}

extension ProductViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}



