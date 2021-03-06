//
//  ProductViewController.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 29/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData
import Photos

class ProductViewController: UIViewController {

    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swPayCard: UISwitch!
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var niBack: UINavigationItem!
    
    var product: Product!
    var state: State!
    var miniImage: UIImage!
    var pickerView: UIPickerView!
    var fetchedResultController: NSFetchedResultsController<State>?
    
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
            btSave.setTitle("Atualizar", for: .normal)
            tfName.text = product.name
            tfPrice.text = String(product.price)
            swPayCard.setOn(product.payCard, animated: true)
            
            if let states = product.state {
                tfState.text = states.name
                state = states
                
            }
            
            if miniImage != nil {
                ivImage.image = miniImage
            } else {
                if let image = product.image as? UIImage {
                    ivImage.image = image
                }
            }
        } else  if miniImage != nil {
            ivImage.image = miniImage
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //MARK - IBActions

    @IBAction func btImageAction(_ sender: Any) {
        
        if checkPermission() {
        
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
        
    }
    
    
    @IBAction func btSaveProductAction(_ sender: Any) {
        
        if (tfName.text?.isEmpty)! || (tfPrice.text?.isEmpty)! || (tfState.text?.isEmpty)! {
            
            tfName.alertIfEmpty()
            tfPrice.alertIfEmpty()
            tfState.alertIfEmpty()
            
        } else {
            
            if product == nil {
                product = Product(context: context)
            }
            
            product.name = tfName.text
            product.price = numberValidation(tfPrice)
            product.state = state
            product.payCard = swPayCard.isOn
            if miniImage != nil {
                product.image = miniImage
            } else {
                product.image = #imageLiteral(resourceName: "gift")
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
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
        
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    func checkPermission() -> Bool {

        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        
        case .authorized:
            print("Access is granted by user")
            return true
        case .notDetermined:
            var autorization = false
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                print("Status is \(newStatus)")
                
                if newStatus == PHAuthorizationStatus.authorized {
                    print("success")
                    autorization = true
                }
            }
            return autorization
        case .restricted:
            print("User do not have access to photo album.")
            return false
        case .denied:
            print("User has denied the permission.")
            return false
        }
    }
    
    @objc func cancel() {
        tfState.resignFirstResponder()
    }

    @objc func done() {
        let indexPath = IndexPath(row: pickerView.selectedRow(inComponent: 0), section: 0)
        if (fetchedResultController?.fetchedObjects?.count)! > 0 {
            tfState.text = fetchedResultController?.object(at: indexPath).name
            state = fetchedResultController?.object(at: indexPath)
            UserDefaults.standard.set(tfState.text, forKey: "state")
            tfPrice.becomeFirstResponder()
        }
        
        cancel()
        
    }
    
    func loadStates() {
        
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController?.delegate = self
        do {
            try fetchedResultController?.performFetch()
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

        dismiss(animated: true, completion: nil)
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let count = fetchedResultController?.fetchedObjects?.count {
            return count
        } else {
            return 0
        }
    }
}

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexPath = IndexPath(row: row, section: 0)
        return fetchedResultController?.object(at: indexPath).name
    }
}

extension ProductViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfState.becomeFirstResponder()
        } else if textField == tfPrice {
            view.endEditing(true)
        }
        return true
    }
}




