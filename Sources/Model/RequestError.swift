//
//  RequestError.swift
//  NetLayer
//
//  Created by Hong Daly on 22/08/2023.
//

import Alamofire
public enum RequestError: Error {
    
    case successWithEmptyBody
    case decode(rawData : Data?)
    case custom(message : String)
    case invalidURL
    case noResponse
    case noConnection
    case unauthorized
    case missingRequestHeader
    case fileCorrupted
    case unexpectedStatusCode
    case unknown
    case badRequest(message : String)
    
    public var customMessage: String {
        switch self {
        case .decode(let rawData):
            if let rawData ,
                let err = String(data: rawData, encoding: .utf8){
                return "Decode error \(err)"
            }
            return "Decode error"
        case .custom(message: let message):
            return message
        case .unauthorized:
            return "Session expired"
        case .missingRequestHeader:
            return "Missing request header"
        case .fileCorrupted:
            return "File Corrupted"
        case .badRequest(message: let message):
            return "Bad Request : \(message)"
        case .successWithEmptyBody:
            return ""
        default:
            return "Unknown error"
        }
    }
}
