//
//  NilOnTypeMismatch.swift
//  NetLayer
//
//  Created by Hong Daly on 02/10/2023.
//

import Foundation






//Object
@propertyWrapper
public struct NilOnTypeMismatch<T:DiffableCodable>  {
    public var wrappedValue: T?
    public init(wrappedValue: T? = nil) {
        self.wrappedValue = wrappedValue
    }
}

extension NilOnTypeMismatch : DiffableCodable {
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.wrappedValue = try container.decode(T.self)
        } catch _ {
            self.wrappedValue = nil
        }
    }
}


//Collection
@propertyWrapper
public struct NilOnTypeMismatchCollection<T:DiffableCodable>  {
    public var wrappedValue: [T]?
    public init(wrappedValue: [T]? = nil) {
        self.wrappedValue = wrappedValue
    }
}

extension NilOnTypeMismatchCollection : DiffableCodable  {
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.wrappedValue = try container.decode([T].self)
        } catch _ {
            self.wrappedValue = nil
        }
    }
}


public extension KeyedDecodingContainer {
    func decode<T:Codable>(_ type: NilOnTypeMismatch<T>.Type,
                 forKey key: Key) throws -> NilOnTypeMismatch<T> {
        return try decodeIfPresent(type, forKey: key) ?? NilOnTypeMismatch<T>(wrappedValue: nil)
  }
}


public extension KeyedDecodingContainer {
    func decode<T:Codable>(_ type: NilOnTypeMismatchCollection<T>.Type,
                 forKey key: Key) throws -> NilOnTypeMismatchCollection<T> {
        return try decodeIfPresent(type, forKey: key) ?? NilOnTypeMismatchCollection<T>(wrappedValue: [])
  }
}
