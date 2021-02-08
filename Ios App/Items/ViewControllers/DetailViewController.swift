//
//  DetailViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 07.02.2021.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemTitleField: UITextField!
    @IBOutlet weak var itemLocationField: UITextField!
    @IBOutlet weak var itemDescriptionField: UITextField!
    
    // MARK: - Public Properties
    
    var item: Item?
    var didEdit: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var isEditor = false
    
    
    // MARK: - Initializers
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideFields()
        itemTitle.text = item?.name
        itemLocation.text = item?.location
        itemDescription.text = item?.description
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Public Methods
    
    func pop(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func hideFields(){
        itemTitleField.isHidden = true
        itemLocationField.isHidden = true
        itemDescriptionField.isHidden = true
    }
    
    private func showFields(){
        let textFields = [itemTitleField, itemLocationField, itemDescriptionField]
        for field in textFields {
            field?.layer.opacity = 0
            field?.isHidden = false
        }
        
        itemTitleField.text = item?.name
        itemLocationField.text = item?.location
        itemDescriptionField.text = item?.description
        
        UIView.animate(withDuration: 0.1) {
            self.itemTitleField.layer.opacity = 1
            self.itemLocationField.layer.opacity = 1
            self.itemDescriptionField.layer.opacity = 1
        }
        
    }
    
    private func showError(_ error: String){
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func saveChanges(){
        let newItem = Item(id: self.item?.id!, name: itemTitleField.text!, location: itemLocationField.text!, description: itemDescriptionField.text!)
        ItemsApiService.shared.update(item: newItem) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.dismissLoadingAlert()
                    self.showError(error)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.didEdit?()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapEdit(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
        if isEditing {
            
            editButton.title = "Save"
            showFields()
        } else {
            saveChanges()
            
            editButton.title = "Edit"
            hideFields()
        }

    }
}
