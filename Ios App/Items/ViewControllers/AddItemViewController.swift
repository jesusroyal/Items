//
//  AddItemViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import UIKit

final class AddItemViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var descriptionOfItem: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Public Properties
    
    var addComplete: (() -> Void)?
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTextFieldDelegates()
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func setupView(){
        addButton.backgroundColor = Colors.green
        addButton.layer.cornerRadius = addButton.frame.height / 2
        
        
        
        name.backgroundColor = Colors.lightGreen
        location.backgroundColor = Colors.lightGreen
        descriptionOfItem.backgroundColor = Colors.lightGreen
    }
    
    private func setTextFieldDelegates(){
        name.delegate = self
        location.delegate = self
        descriptionOfItem.delegate = self
    }
    
    private func getNewItem() -> Item? {
        let name = self.name.text!
        if name.isEmpty {
            showError("Введите название")
            return nil
        }
        
        let discriptionString = self.descriptionOfItem.text!
        if discriptionString.isEmpty {
            showError("Введите описание")
            return nil
        }
        
        let location = self.location.text!
        if location.isEmpty {
            showError("Введите расположение")
            return nil
        }
        
        return Item(name: name, location: location, description: discriptionString)
    }
    
    private func showError(_ error: String){
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func addItem(_ sender: UIButton) {
        
        if let item = getNewItem() {
            presentLoadingAlert()
            ItemsApiService.shared.add(item: item) { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.showError(error)
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dismissLoadingAlert {
                            self.addComplete?()
                        }
                    }
                }
                
            }
        }
    }

}

    //MARK: -UITextFieldDelegate + Animation

extension AddItemViewController: UITextFieldDelegate {

    private func swapFirstResponder(_ firstTextField: UITextField, for secondTextField: UITextField) {
        firstTextField.resignFirstResponder()
        secondTextField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case name:
            swapFirstResponder(textField, for: descriptionOfItem)
            return false
        case descriptionOfItem:
            swapFirstResponder(textField, for: location)
            return false

        case location:
            textField.resignFirstResponder()
            return false
        default:
            return true

        }
    }

    private func moveViewToTextField(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y -= (textField.frame.origin.y - self.name.frame.origin.y)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case name:
            return
        case descriptionOfItem:
            moveViewToTextField(descriptionOfItem)

        case location:
            moveViewToTextField(location)
            return
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.2) {
                self.view.frame.origin.y = 0
            }

        }
    }
}
