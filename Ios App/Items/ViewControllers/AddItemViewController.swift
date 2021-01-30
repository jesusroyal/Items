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
    @IBOutlet weak var descriptionText: UITextView!
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func setupView(){
        addButton.backgroundColor = Colors.green
        addButton.layer.cornerRadius = addButton.frame.height / 2
    }
    
    private func getNewItem() -> Item? {
        let name = self.name.text!
        let location = self.location.text!
        let discriptionString = self.descriptionText.text
        return Item(name: name, location: location, description: discriptionString!)
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
            ItemsApiService.shared.add(item: item) { (arh) in
                DispatchQueue.main.async {
                    self.dismissLoadingAlert()
                }
            }
        }
    }

}
