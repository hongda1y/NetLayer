//
//  NetSearchableClient.swift
//  NetLayer
//
//  Created by Hong Daly on 30/10/2023.
//

import Foundation
import Alamofire


public protocol NetSearchableClient  {
    func search()
    var searchFilter: Parameters? {get set}
}






