//
//  ItemsApiService.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import Foundation

final class ItemsApiService {
    private let url = URL(string: "http://127.0.0.1:8080/items")!
    private let session = URLSession.shared
    
    func getItems( completionHandler: @escaping ([Item]?) -> Void){
        let task = session.dataTask(with: url){ (data, resp, err) in
            if let jsonString = String(data: data!, encoding: .utf8) {
                        print(jsonString)
                     }
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            if let items = try? JSONDecoder().decode([Item].self, from: data){
                completionHandler(items)
            }
        }
        task.resume()
    }
    
    func add(item: Item, completionHandler: @escaping (Bool) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(item)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func delete(item: Item, completionHandler: @escaping (Bool) -> Void){
        let id = item.id
        
        let deleteUrl = URL(string: "http://127.0.0.1:8080/items/\(id!)")!
        var request = URLRequest(url: deleteUrl)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request)
        task.resume()
        
    }
}