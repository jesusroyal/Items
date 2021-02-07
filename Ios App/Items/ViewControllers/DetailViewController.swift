//
//  DetailViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 07.02.2021.
//

import UIKit

class DetailViewController: UIViewController {

    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTitle.text = item?.name
        itemLocation.text = item?.location
        itemDescription.text = item?.description
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBAction func didTapEdit(_ sender: UIBarButtonItem) {
    }
    

}
