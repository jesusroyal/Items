//
//  HomeTableViewController.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import UIKit

final class HomeTableViewController: UITableViewController {
    
    private let reuseIdentifier = "itemCell"
    private var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        setupView()
       
    }
    
    private func getItems(){
        self.presentLoadingAlert()
        ItemsApiService.shared.fetchItems { (items) in
            guard let items = items else { return }
            DispatchQueue.main.async {
                self.items = items
                self.dismissLoadingAlert {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupView(){
        self.title = "Items"
        
        self.navigationController?.navigationBar.tintColor = Colors.green
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ItemsApiService.shared.delete(item: items[indexPath.row]) { (error) in }
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAdd" {
            guard let destination = segue.destination as? AddItemViewController else { return }
            destination.addComplete = { [weak self] in
                self?.getItems()
            }
        }
    }
}
