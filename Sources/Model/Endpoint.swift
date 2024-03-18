
import Alamofire


public protocol Endpoint {
    var path        : String { get }
    var method      : HTTPMethod { get }
    var parameters  : Parameters? { get }
    var encoding    : ParameterEncoding? {get}
    var debugMode   : Bool { get }
}

public struct DefaultEndpoint : Endpoint {
    
    public var debugMode: Bool
    
    public init(path: String,
                method: HTTPMethod,
                parameters: Parameters? = nil,
                encoding: ParameterEncoding? = nil,
                debugMode : Bool = false) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.debugMode = debugMode
    }
    
    public var path: String
    
    public var method: Alamofire.HTTPMethod
    
    public var parameters: Alamofire.Parameters?
    
    public var encoding: Alamofire.ParameterEncoding?
    
    
}
