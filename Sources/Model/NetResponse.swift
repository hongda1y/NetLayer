//
//  NetResponse.swift
//  NetLayer
//
//  Created by Hong Daly on 23/08/2023.
//

import Foundation
public struct NetResponse<T:Codable> : Codable {
    public var count : Int?
    public var next : String?
    public var previous : String?
    public var results : [T]?
    public var message : String?
    public init(count: Int?,
                next: String? = nil,
                previous: String? = nil,
                results: [T]? = nil,
                message: String? = nil) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
        self.message = message
    }
    
    
    enum CodingKeys: CodingKey {
        case count
        case next
        case previous
        case results
        case message
    }
}

