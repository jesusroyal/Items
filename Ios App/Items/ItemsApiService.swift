//
//  ItemsApiService.swift
//  Items
//
//  Created by Mike Shevelinsky on 16.01.2021.
//

import Foundation

final class ItemsApiService {
    
    private init() { }
    static let shared = ItemsApiService()
    
    private var url: String?
    private let session = URLSession.shared
    
    private var baseURL: URL {
        return URL(string: url!)!
    }
    
    private func deleteURL(for id: UUID) -> URL {
        URL(string: "http://\(url!)/items/\(id)")!
    }
    
    func setIP(_ ip: String){
        url = ip
    }
    
    func fetchItems(completionHandler: @escaping ([Item]?) -> Void, errorHandler: ((String) -> Void)? = nil){
        let task = session.dataTask(with: baseURL){ (data, resp, err) in
            
            if let err = err {
                if let handler = errorHandler {
                    handler(err.localizedDescription)
                }
                return
            }
            
            if let data = data, let items = try? JSONDecoder().decode([Item].self, from: data){
                completionHandler(items)
            }
        }
        
        task.resume()
    }
    
    func add(item: Item, errorHandler: @escaping (String?) -> Void){
        let request = getPostRequest(with: item)
        let task = session.dataTask(with: request){data, resp, err in
            if err == nil {
                errorHandler(nil)
            } else {
                errorHandler(err?.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func delete(item: Item, completionHandler: @escaping (Bool) -> Void){
        let id = item.id
        
        
        var request = URLRequest(url: deleteURL(for: id!))
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func update(item: Item, errorHandler: ((String?) -> Void)? = nil){
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(item)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request){data, resp, err in
            if err == nil {
                errorHandler?(nil)
            } else {
                errorHandler?(err?.localizedDescription)
            }
            
        }
        task.resume()
        
    }
    
    private func getPostRequest(with item: Item) -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(item)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
