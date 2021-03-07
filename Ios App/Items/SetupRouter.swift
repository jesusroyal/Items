//
//  SetupRouter.swift
//  Items
//
//  Created by Mike Shevelinsky on 02.03.2021.
//

import Foundation


final class SetupRouter {
    //MARK: - Singleton
    private init() { }
    static let shared = SetupRouter()
    
    private let defaults = UserDefaults.standard
    private let ip = "ip"
    
    let didSetIP = NSNotification.Name(rawValue: "Done")
    
    func getIP() -> String? {
        return defaults.string(forKey: ip)
    }
    
    func setIP(_ adress: String){
        NotificationCenter.default.post(name: didSetIP, object: nil)
        defaults.set(adress, forKey: ip)
    }
    
    func setupIsNeeded() -> Bool {
        if let _ = defaults.string(forKey: ip) {
            return false
        } else {
            return true
        }
    }
    
}
