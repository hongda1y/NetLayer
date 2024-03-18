//
//  NetFile.swift
//  NetLayer
//
//  Created by Hong Daly on 22/08/2023.
//

import Foundation

public enum NetFileType {
    case data(Data)
    case path(URL)
    case none
}

public struct NetFile {
        
    /// name : File name
    public var name         : String
    
    /// type : File type
    public var type         : NetFileType
    
    /// mimeType : File mimeType
    public var mimeType     : String?
    
    /// formDataKey : Field
    public var field  : String
    
    
    /// Init
    /// - Parameters:
    ///   - name: File name
    ///   - pathUrl: File url path
    ///   - rawData: File Data
    ///   - mimeType: File mimeType
    ///   - field: File key of server
    ///
    public init(name: String?,
                type: NetFileType = .none,
                mimeType: String? = nil,
                field: String) {
        self.name = name ?? "\(Date().timeIntervalSince1970)"
        self.type = type
        self.mimeType = mimeType
        self.field = field
    }
    
}
