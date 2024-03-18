//
//  Encodable+Parameter.swift
//  NetLayer
//
//  Created by Hong Daly on 22/08/2023.
//

import Alamofire

public extension Encodable {
    var parameters : Parameters? {
        guard let data = try? JSONEncoder()
            .encode(self) else { return nil }
        let jsonObject = try? JSONSerialization
            .jsonObject(with: data,options: .allowFragments)
        return jsonObject.flatMap { $0 as? [String: Any] }
    }
    
    var rawData : Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}



public extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
