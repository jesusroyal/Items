//
//  AddItemViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import UIKit

final class AddItemViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
   
    @IBAction func addItem(_ sender: UIButton) {
        let name = self.name.text!
        let location = self.location.text!
        let item = Item(name: name, location: location, description: "test description")
        ItemsApiService().add(item: item) { (arh) in
            print(arh)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
