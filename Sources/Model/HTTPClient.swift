//
//  HTTPClient.swift
//  NetLayer
//
//  Created by Hong Daly on 22/08/2023.
//

import Alamofire

public protocol HTTPClient {
    var base: String { get }
    var headers: HTTPHeaders { get }
    var session : Session { get }
    
    func request<T: Decodable>(endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, RequestError>
    
    func upload<T:Decodable>(endpoint: Endpoint,
                             file : NetFile,
                             uploadProgress : ((Progress) -> Void)?,
                             responseModel: T.Type) async -> Result<T, RequestError>
    
    func resultHandler<T:Decodable>(_ result : DataResponse<Data,AFError>,
                             _ responseModel : T.Type) -> Result<T, RequestError>
}

//MARK: VARS
public extension HTTPClient {
    var session : Session {
        Session.default
    }
    
    var base : String {
        ""
    }
    
    var headers : HTTPHeaders {
        return []
    }
}


//MARK: Send Request
public extension HTTPClient {
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        let urlString = base + endpoint.path
        print(#function,urlString)
        if endpoint.debugMode ,
           let params =  endpoint.parameters{
            print(#function,params)
        }
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        print(#function,url)
        
        guard headers.count > 0 else {
            return .failure(.missingRequestHeader)
        }
        let result = await session
            .request(url,
                     method: endpoint.method,
                     parameters: endpoint.parameters,
                     encoding: endpoint.encoding ?? URLEncoding.default,
                     headers: headers)
            .serializingData()
            .response
        
        if let error = result.error {
            print(#function,error.localizedDescription)
        }
        
        
        
        if endpoint.debugMode {
            if let data = result.data {
                print(#function,
                      String(data: data, encoding: .utf8) ?? "No Log")
            }
        }
        
        return resultHandler(result, responseModel)
    }
}


//MARK: Upload
public extension HTTPClient {
    func upload<T:Decodable>(endpoint: Endpoint,
                             file : NetFile,
                             uploadProgress : ((Progress) -> Void)?,
                             responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        let urlString = base + endpoint.path
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        guard headers.count > 0 else {
            return .failure(.missingRequestHeader)
        }
        
        let formData = MultipartFormData()
        switch file.type {
        case .data(let data):
            formData.append(data,
                            withName: file.field,
                            fileName: file.name,
                            mimeType: file.mimeType)
            break
        case .path(let pathUrl):
            formData.append(pathUrl, withName: file.field)
            break
        case .none:
            break
        }
        
        if let params = endpoint.parameters {
            for (key, value) in params {
                formData
                    .append((value as AnyObject)
                        .data(using: String.Encoding.utf8.rawValue)!,
                            withName: key)
            }
        }
        
        print(#function,url)
        if endpoint.debugMode ,
           let params =  endpoint.parameters{
            print(#function,params)
        }
        
        let result = await session
            .upload(multipartFormData: formData,
                    to: url,
                    method: endpoint.method,
                    headers: headers)
            .uploadProgress(closure: { progress in
                uploadProgress?(progress)
            })
            .serializingData()
            .response
        
        if let error = result.error {
            print(#function,error)
        }
        
        
        if endpoint.debugMode {
            if let data = result.data {
                print(#function,
                      String(data: data, encoding: .utf8) ?? "No Log")
            }
        }
        
        return resultHandler(result, responseModel)
    }
    
    
    func upload<T:Decodable>(endpoint: Endpoint,
                             files : [NetFile],
                             overideFileKey: String = "files",
                             uploadProgress : ((Progress) -> Void)?,
                             responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        let urlString = base + endpoint.path
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        guard headers.count > 0 else {
            return .failure(.missingRequestHeader)
        }
        
        let formData = MultipartFormData()
        
        for file in files {
            switch file.type {
            case .data(let data):
                formData.append(data,
                                withName: overideFileKey,
                                fileName: file.name,
                                mimeType: file.mimeType)
              
                break
            case .path(let pathUrl):
                formData.append(pathUrl,
                                withName: overideFileKey)
                break
            case .none:
                break
            }
        }
        
    
        if let params = endpoint.parameters {
            for (key, value) in params {
                formData
                    .append((value as AnyObject)
                        .data(using: String.Encoding.utf8.rawValue)!,
                            withName: key)
            }
        }
        
        
        
        let result = await session
            .upload(multipartFormData: formData,
                    to: url,
                    method: endpoint.method,
                    headers: headers)
            .uploadProgress(closure: { progress in
                uploadProgress?(progress)
            })
            .serializingData()
            .response
            
        
        if let error = result.error {
            print(#function,error)
        }
        
        
        if endpoint.debugMode {
            if let data = result.data {
                print(#function,
                      String(data: data, encoding: .utf8) ?? "No Log")
            }
        }
        
        return resultHandler(result, responseModel)
    }
}



//MARK: Check Result
public extension HTTPClient {
    func resultHandler<T:Decodable>(_ result : DataResponse<Data,AFError>,
                             _ responseModel : T.Type) -> Result<T, RequestError> {
        
        guard let response = result.response else {
            return .failure(.noResponse)
        }
//        print(#function,response)
        
        switch response.statusCode {
        case 200...299:
            
            if response.statusCode == 204 {
                return .failure(.successWithEmptyBody)
            }
            
            guard let data = result.data ,
                  let obj = decodeObject(data: data,responseModel: responseModel) else {
                return .failure(.decode(rawData: result.data))
            }
            
            return .success(obj)
            
        case 400:
            if let data = result.data,
               let obj = decodeObject(data: data,
                                      responseModel: BadRequestResponse.self) {
                return .failure(.badRequest(message: obj.message ?? ""))
            }
            return .failure(.badRequest(message: ""))
        case 401:
            return .failure(.unauthorized)
        default:
            return .failure(.unexpectedStatusCode)
        }
    }
}

extension HTTPClient {
    func decodeObject<T:Decodable>(data : Data?,
                                   responseModel : T.Type) -> T? {
        guard let data = data else { return nil }
        
        do {
            let obj = try JSONDecoder().decode(responseModel,from:data)
            return obj
        } catch let error {
            print(#function,String(describing: error))
        }
        return nil
    }
}


fileprivate class BadRequestResponse : Codable {
    var message : String?
}


