/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class DataController{
    
    static var shared = DataController()
    
    let store: UserDefaults
    
    private init() {
        self.store = UserDefaults.standard
    }
    
    func save(forKey key: String, value: Codable) {
        let storeString = value.toJSON()
        print(storeString)
        store.set(storeString, forKey: key)
    }
    
    func load<T : Codable>(forKey key: String) -> T? {
        if let storedString = store.value(forKey: key) as? String {
            return T.fromJSON(encoded: storedString)
        }
        print("no saved data available for \(key)")
        return nil
    }
    
}
