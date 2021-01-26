//
//  HomeTableViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import UIKit

final class HomeTableViewController: UITableViewController {
    
    private let reuseIdentifier = "itemCell"
    private let apiService = ItemsApiService()
    private var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.getItems { (items) in
            guard let items = items else {return}
            self.items = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = items[indexPath.row].name

        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            apiService.delete(item: items[indexPath.row]) { (aga) in
                print(aga)
            }
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

}
