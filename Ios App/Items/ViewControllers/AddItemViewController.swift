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
    
    private var isLoading = false
    
    // MARK: - Initializers
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    private func presentLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Loading", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        isLoading = true
        present(alert, animated: true)
    }
    
    private func dismissLoadingAlert() {
        dismiss(animated: true) {
            self.isLoading = false
            self.dismiss(animated: true, completion: {
                if self.addComplete != nil {
                    self.addComplete!()
                }
            })
        }
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
                        self.dismissLoadingAlert()
                    }
                }
                
            }
        }
    }

}
