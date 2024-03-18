//
//  NetPaginEndpoint.swift
//  NetLayer
//
//  Created by Hong Daly on 23/08/2023.
//

import Alamofire

public class NetPagingEndpoint : Endpoint {
    
    public var debugMode: Bool

    public var path: String
    
    public var method: Alamofire.HTTPMethod
    
    public var parameters: Alamofire.Parameters?
    
    public var encoding: Alamofire.ParameterEncoding?
    
    public init(path: String,
                parameters: Alamofire.Parameters? = nil,
                encoding: Alamofire.ParameterEncoding? = nil,
                debugMode : Bool = false) {
        self.path = path
        self.method = .get
        self.parameters = parameters
        self.debugMode = debugMode
        self.encoding = encoding
    }
}
