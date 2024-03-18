//
//  DiffableCodable.swift
//  NetLayer
//
//  Created by Hong Daly on 17/10/2023.
//

import ListDiff

public typealias _DiffableCodable = Codable & Equatable & Diffable


public protocol DiffableCodable : _DiffableCodable {
    var id : Int? { get set }
}


extension DiffableCodable {
    
    public var diffIdentifier: AnyHashable {
        id
    }
    
    public var id : Int? {
        get {
            return self.id ?? 0
        }
        set {
            self.id = newValue
        }
    }
}
