//
//  SetupViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 02.03.2021.
//

import UIKit

final class SetupViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var address: UITextField!
    
    // MARK: - Public Properties
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Lifecycle
    // MARK: - Public Methods
    // MARK: - Private Methods
    
    private func getAdress() -> String? {
        guard let ip = address.text else { return nil }
        if ip.isEmpty { return nil}
        return ip
    }
    
    // MARK: - IBActions
    
    
    @IBAction func didSubmit(_ sender: UIButton) {
        guard let adress = getAdress() else { return }
        SetupRouter.shared.setIP(adress)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   

}
