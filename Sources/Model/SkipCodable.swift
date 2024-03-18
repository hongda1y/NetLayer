//
//  SkipCodable.swift
//  NetLayer
//
//  Created by Hong Daly on 02/10/2023.
//

import Foundation
@propertyWrapper
public struct SkipEncode<T> {
    public var wrappedValue: T
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

extension SkipEncode: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      self.wrappedValue = try container.decode(T.self)
   }
}

extension SkipEncode: Encodable {
    public func encode(to encoder: Encoder) throws {
      // nothing to do here
   }
}

public extension KeyedEncodingContainer {
   mutating func encode<T>(_ value: SkipEncode<T>, forKey key: K) throws {
      // overload, but do nothing
   }
}
