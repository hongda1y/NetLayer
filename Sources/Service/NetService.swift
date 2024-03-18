


import Alamofire
open class NetService : HTTPClient {
    
    open var headers: HTTPHeaders {
        []
    }
    
    open var session: Session {
        Session.default
    }
    
    open var base: String {
        ""
    }

    public init() {}
}




