//
//  BaseViewModel.swift
//  NetLayer
//
//  Created by Hong Daly on 23/08/2023.
//

import Foundation

public enum BaseViewModelEvent {
    case loading
    case error(error : RequestError)
    case complete
    case completeWithId(id:String)
    case noMoreData
}


open class BaseViewModel {
    
    public init() {}
    ///
    /// onLoading : Call when model request network
    ///
    
    
    public var onLoading : VoidCallback?
    
    
    ///
    /// onError : Call when error/response complete with error
    ///
    
    
    
    public var onError : ValueCallback<RequestError>?
    
    
    ///
    /// onComplete : Call when response complete
    ///
    
    
    public var onComplete : VoidCallback?
    
    
    ///
    /// onComplete : Call when response complete(id)
    ///
    
    public var onCompleteWithId : ValueCallback<String>?
    
    
    ///
    /// onNoMoreData : Call when response data is empty (results param)
    ///
    public var onNoMoreData : VoidCallback?
    
    
    
    public func fire(events : BaseViewModelEvent...) {
        Task { @MainActor in
            for event in events {
                switch event {
                case .loading:
                    onLoading?()
                    break
                case .error(error: let error):
                    onError?(error)
                case .complete:
                    onComplete?()
                    break
                case .completeWithId(let id):
                    onCompleteWithId?(id)
                    break
                case .noMoreData:
                    onNoMoreData?()
                    break
                }
            }
        }
    }
    
}



