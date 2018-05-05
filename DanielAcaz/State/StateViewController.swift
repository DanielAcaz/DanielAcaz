//
//  StateViewController.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 30/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit
import CoreData

enum StateType {
    case add
    case edit
}

class StateViewController: UIViewController {

    
    @IBOutlet weak var tfDolar: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tvStateList: UITableView!
    @IBOutlet weak var niReturnProduct: UINavigationItem!
    
    var dataSource: [State] = []
    var product: Product!
    var labelEmptyList = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    //MARK: - Override Methods
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if(identifier == "addState"){
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvStateList.delegate = self
        tvStateList.dataSource = self
        //loadStates()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tfDolar.text = UserDefaults.standard.string(forKey: "dolar")
        tfIOF.text = UserDefaults.standard.string(forKey: "iof")
        loadStates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(tfDolar.text, forKey: "dolar")
        UserDefaults.standard.set(tfIOF.text, forKey: "iof")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - My Methods
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tvStateList.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: StateType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do Estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto do Estado"
            textField.keyboardType = .decimalPad
            if let tax = state?.tax {
                textField.text = String(tax)
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            //state.tax = Double(alert.textFields?.last?.text ?? "0")!
            state.tax = self.numberValidation((alert.textFields?.last!)!)
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteTest(tableView: UITableView, index: IndexPath){
        let message = "Ao deletar este estado, todos as compras relacionadas com ele também serão apagados! Deseja continuar? "
        let alert = UIAlertController(title: "ATENÇÃO", message: message, preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
            let state = self.dataSource[index.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: index.row)
            tableView.deleteRows(at: [index], with: .fade)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    
    @IBAction func btAddStateAction(_ sender: Any) {
        self.showAlert(type: .add, state: nil)
    }
    
    
}

// MARK: - Extensions
extension StateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = dataSource[indexPath.row]
        self.showAlert(type: .edit, state: state)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Deletar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.deleteTest(tableView: tableView, index: indexPath)
        }
    
        return [deleteAction]
    }
}

// MARK: - Extensions
extension StateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            labelEmptyList.isHidden = false
            labelEmptyList.text = "Lista de estado vazia"
            labelEmptyList.textAlignment = .center
            labelEmptyList.textColor = .black
            tableView.backgroundView = labelEmptyList
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            labelEmptyList.isHidden = true
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = String(state.tax)
        cell.detailTextLabel?.textColor = UIColor.red
        
       return cell
    }
}

extension StateViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let number = numberValidation(textField)
        if number == 0 {
            textField.becomeFirstResponder()
        }
    }
    
}









