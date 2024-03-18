


import Alamofire
import Foundation
import ListDiff


fileprivate protocol _REPO {
    func initLoad() async
    func loadMore(reload: Bool) async
    func resetData()
    
}


open class NetPagingViewModel<T:DiffableCodable>  : BaseViewModel,_REPO {
    
    public override init() {}
    
    open var service  : HTTPClient {
        NetService()
    }
    
    public var section : Int = 0
    
    public var limit   : Int = 20
    
    public var initLoading : Bool = true
    
    public var enableLoadMore: Bool = true
    
    public var filter : Parameters?
   
    public var placeholderCount = 20
    
    open var endpoint : NetPagingEndpoint {
        .init(path: "")
    }
    
    public var inserts : [IndexPath] = []
    public var deletes : [IndexPath] = []
    
    
    public var currentPage = 1
    public var items : [T] = []
    
    
    
    open func handleData(data : NetResponse<T>,
                            _ reload: Bool) {
      
        if (reload) {
            items = []
            modifyItems()
        }
        
        let newItems : [T] = data.results ?? []
        let nextPage : String = data.next ?? ""
        
        if newItems.isEmpty {
            inserts = []
            enableLoadMore = false
            fire(events: .complete,.noMoreData)
            return
        }
        
        handleIndexPath(newItems)
        items.append(contentsOf: newItems)
    
        modifyItems()
        
        if nextPage.isEmpty {
            enableLoadMore = false
            fire(events: .complete,.noMoreData)
            return
        }
        
        currentPage += 1
        fire(events: .complete)
    }
    
    open func modifyItems() {}
}

public extension NetPagingViewModel {
    
    func resetData() {
        currentPage = 1
        items = []
        modifyItems()
        fire(events: .complete)
    }
    
    func initLoad() async {
        currentPage = 1
        initLoading = true
        enableLoadMore = true
        await loadMore(reload: true)
    }
    
    func loadMore(reload: Bool = false)  async {
        
        if !enableLoadMore {
            return
        }
        
        print(#function,endpoint.parameters)
        let result = await service
            .request(endpoint: endpoint,
                     responseModel: NetResponse<T>.self)
        switch result {
        case .success(let data):
            handleData(data: data,reload)
            return
        case .failure(let failure):
            print(#function,failure)
            fire(events: .error(error: failure))
            return
        }
    }
    
    private func handleIndexPath(_ newsItems : [T]) {
        let startIndex = items.count
        inserts = []
        for (index,_) in newsItems.enumerated() {
            let row = startIndex + index
            let indexPath: IndexPath = .init(row: row, section: section)
            inserts.append(indexPath)
        }
//        print(#function,inserts)
    }
}
 
