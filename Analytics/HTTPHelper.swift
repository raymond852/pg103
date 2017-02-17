//
//  HTTPHelper.swift
//  pg
//
//  Created by hy110831 on 8/24/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import Bolts
import SwiftyJSON

protocol ApiError {
    func getApiErrorMessage()->String
    func getApiErrorCode()->ApiErrorCode
}

extension NSError:ApiError {
    func getApiErrorMessage()->String {
        return (self.userInfo["_ApiErrorMessage"] as! String)
    }
    
    func getApiErrorCode()->ApiErrorCode {
        return ApiErrorCode(rawValue:self.code)!
    }
}

enum ApiErrorCode:Int {
    case `internal` = 1000
    case emptyResponse = 1001
    case protocolError = 1002
    
    case parseRequestJSONError = 2000
    case parseResponseJSONError = 2001
    
    case requestDataInvalid = 3000
    
    case responseDataInvalid = 3001
    
    // happend when sever return a serious error, e.g (500 internal error)
    case serverError = 3002

    
    func defaultErrorMessage()->String {
        switch self {
        case .internal:
            return "内部错误";
        case .emptyResponse:
            return "服务器返回为空"
        case .protocolError:
            return "服务器返回协议错误或不支持该HTTP方法"
        case .parseRequestJSONError:
            return "解析请求数据失败"
        case .parseResponseJSONError:
            return "解析服务器响应数据失败"
        case .requestDataInvalid:
            return "请求数据不正确"
        case .responseDataInvalid:
            return "服务器返回数据缺少字段"
        case .serverError:
            return "服务器错误"
        }
    }
}

class HTTPHelper : NSObject {
    
    static let ERROR_DOMAIN = "PG"
    static let ERROR_MESSAGE_KEY = "errMsg"
    static var SERVER_URL = "http://pg.meedoo.cc"
    static let USER_AGENT = "PG 0.0.1" 
    
    static let REQUEST_TIMEOUT:TimeInterval = 60
    
    // MARK: private function
    static func prepareApiUrlForPath(path:String)-> String{
        return HTTPHelper.SERVER_URL + path
    }
    
    fileprivate static func assembleError(code:ApiErrorCode, errorMessage:String?)->NSError {
        return NSError(domain: HTTPHelper.ERROR_DOMAIN, code: code.rawValue, userInfo: ["_ApiErrorMessage": errorMessage ?? code.defaultErrorMessage()])
    }
    
    fileprivate static func assembleError(code:ApiErrorCode, error:NSError)-> NSError {
        var userInfoWrapper:[AnyHashable: Any]
        userInfoWrapper = ["_NSErrorCode" : NSNumber(value: error.code), "_NSErrorDomain": error.domain as Any]
        userInfoWrapper.merge(error.userInfo)
        
        userInfoWrapper["_ApiErrorMessage"] = code.defaultErrorMessage()
        if error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorTimedOut:
                userInfoWrapper["_ApiErrorMessage"] = "请求超时"
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                userInfoWrapper["_ApiErrorMessage"] = "请求失败,请检测网络连接"
            case NSURLErrorCannotFindHost,NSURLErrorDNSLookupFailed, NSURLErrorCannotConnectToHost:
                userInfoWrapper["_ApiErrorMessage"] = "连接服务器失败"
            case NSURLErrorZeroByteResource:
                userInfoWrapper["_ApiErrorMessage"] = "服务器返回为空"
            default: break
            }
        }
        return NSError(domain: HTTPHelper.ERROR_DOMAIN, code: code.rawValue, userInfo: userInfoWrapper)
    }
    
    fileprivate static func generateBoundaryString() -> String {
        return "----\(NSUUID().uuidString)"
    }
    
    
    private static func handleResponse(bfs:BFTaskCompletionSource<AnyObject>, data:NSData?, response:URLResponse?, error:NSError?) {
        if let err = error {
            return bfs.setError(HTTPHelper.assembleError(code:ApiErrorCode.internal, error: err))
        }
        if let retData = data as? Data{
            let resStr = NSString(data: retData, encoding: String.Encoding.utf8.rawValue)
            print(resStr)
            
            var json = JSON(data: retData)
            if  json.error != nil {
                return bfs.setError(HTTPHelper.assembleError(code:ApiErrorCode.parseResponseJSONError, errorMessage: nil))
            } else {
                if let res = (response as? HTTPURLResponse) {
                    
                    if json.exists() {
                        json["_statusCode"].number = NSNumber(value: res.statusCode)
                    }
                    
                    if res.statusCode != 200 && res.statusCode != 201 && res.statusCode != 204 {
                        if res.statusCode >= 400 && res.statusCode < 500 {
                            return bfs.setError(HTTPHelper.assembleError(code :ApiErrorCode.requestDataInvalid, errorMessage: json[HTTPHelper.ERROR_MESSAGE_KEY].string))
                        } else if res.statusCode >= 500 {
                            return bfs.setError(HTTPHelper.assembleError(code :ApiErrorCode.serverError, errorMessage: json[HTTPHelper.ERROR_MESSAGE_KEY].string))
                        } else {
                            return bfs.setError(HTTPHelper.assembleError(code :ApiErrorCode.internal, errorMessage: json[HTTPHelper.ERROR_MESSAGE_KEY].string))
                        }
                    }
                    
                    if json["statusCode"].int != 200 {
                        return bfs.setError(HTTPHelper.assembleError(code: ApiErrorCode.requestDataInvalid, errorMessage: json[HTTPHelper.ERROR_MESSAGE_KEY].string))
                    }
                    
                    do {
                        let result = try json.rawData()
                        return bfs.setResult(result as AnyObject?)
                    } catch {
                        return bfs.setError(HTTPHelper.assembleError(code: ApiErrorCode.parseResponseJSONError, errorMessage: nil))
                    }
                    
                } else {
                    return bfs.setError(HTTPHelper.assembleError(code: .protocolError, errorMessage: nil))
                }
            }
        } else {
            return bfs.setError(HTTPHelper.assembleError(code: .emptyResponse, errorMessage: nil))
        }
    }
    
    func baseHTTPFormPutRequest(url: String, params: [String: Any],requestHeaders: [String: String]?)-> BFTask<AnyObject> {
        return baseHTTPFormRequest(method: "PUT", url: url, params: params, requestHeaders: requestHeaders)
    }
    
    func baseHTTPFormPostRequest(url: String, params: [String: Any],
                                 requestHeaders:[String:String]?)->BFTask<AnyObject> {
        return baseHTTPFormRequest(method: "POST", url: url, params: params, requestHeaders: requestHeaders)
    }
    
    func baseHTTPFormRequest(method:String, url: String, params: [String: Any], requestHeaders: [String: String]?, keySequence:[String]? = nil)-> BFTask<AnyObject> {
        
        return BFTask(from: BFExecutor(dispatchQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)) , with: { () -> AnyObject in
            let bfs:BFTaskCompletionSource = BFTaskCompletionSource<AnyObject>()
            
            let config = URLSessionConfiguration.ephemeral
            config.timeoutIntervalForRequest = TimeInterval(HTTPHelper.REQUEST_TIMEOUT)
            
            let request = NSMutableURLRequest()
            request.url = NSURL(string: url)! as URL
            request.httpMethod = method
            
            request.setValue(HTTPHelper.USER_AGENT, forHTTPHeaderField: "User-Agent")
            if requestHeaders != nil {
                for (headerField, headerVal) in requestHeaders! {
                    request.setValue(headerVal, forHTTPHeaderField: headerField)
                }
            }
            
            let boundary = HTTPHelper.generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            if let ks = keySequence {
                for key  in ks {
                    if let value = params[key] {
                        autoreleasepool {
                            if let image = value as? UIImage {
                                var finalImage = image
                                if image.size.width > 1028 {
                                    finalImage = image.resizeToWidth(1028)
                                }
                                let imageData = UIImageJPEGRepresentation(finalImage, 0.6)
                                
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Type:image/jpeg \r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append(imageData!)
                                body.append("\r\n".data(using: String.Encoding.utf8)!)
                            } else if (value as? NSString) != nil {
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                                
                            } else if (value as? NSData) != nil {
                                // assume that the data represents an image
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Type:image/jpeg \r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append((value as! NSData) as Data)
                                body.append("\r\n".data(using: String.Encoding.utf8)!)
                            }
                        }
                    }
                }
            }
            
            for (key, value) in params {
                if let ks = keySequence {
                    var shouldIgnoreKey = false
                    for kskey in ks {
                        if kskey == key {
                            shouldIgnoreKey = true
                            break
                        }
                    }
                    if shouldIgnoreKey {
                        continue
                    }
                }
                autoreleasepool {
                    if let image = value as? UIImage {
                        var finalImage = image
                        if image.size.width > 1028 {
                            finalImage = image.resizeToWidth(1028)
                        }
                        var imageData = UIImageJPEGRepresentation(finalImage, 1)
                        
                        if imageData!.count > 500000 {
                            imageData = UIImageJPEGRepresentation(finalImage, 0.6)
                        }
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Type:image/jpeg \r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append(imageData!)
                        body.append("\r\n".data(using: String.Encoding.utf8)!)
                    } else if (value as? String) != nil {
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                        
                    } else if (value as? Data) != nil {
                        // assume that the data represents an image
                        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8
                            )!)
                        body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using:
                            String.Encoding.utf8)!)
                        body.append("Content-Type:image/jpeg \r\n\r\n".data(using: String.Encoding.utf8)!)
                        body.append(value as! Data)
                        body.append("\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
            }
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request as URLRequest) {
                ( data, response, error) in
                HTTPHelper.handleResponse(bfs: bfs, data: data as NSData?, response: response, error: error as NSError?)
            }
            task.resume()
            return bfs.task as AnyObject
        })
    }
    
    
    func baseHttpRequest(url:String, method:String, params: [String: Any]?, requestHeaders: [String: String]?)->BFTask<AnyObject> {
        
        
        //        let bfs:BFTaskCompletionSource = BFTaskCompletionSource()
        return BFTask(from: BFExecutor(dispatchQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)), with: { () -> Any in
            
            let bfs = BFTaskCompletionSource<AnyObject>()
            
            // don't save anything to session, making it stateless
            let config = URLSessionConfiguration.ephemeral
            config.timeoutIntervalForRequest = TimeInterval(HTTPHelper.REQUEST_TIMEOUT)
            
            let request = NSMutableURLRequest()
            request.url = NSURL(string: url)! as URL
            if method == "POST" || method == "PUT" {
                request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            } else if method == "GET" {
                if params != nil {
                    let parameterString = params!.stringFromHttpParameters()
                    let requestURL = NSURL(string:"\(url)?\(parameterString)")
                    request.url = requestURL as URL?
                } else {
                    request.url = NSURL(string: url)! as URL
                }
            } else if method != "DELETE"{
                bfs.setError(HTTPHelper.assembleError(code:ApiErrorCode.protocolError, errorMessage: nil))
                return bfs.task
            }
            
            request.httpMethod = method
            request.setValue(HTTPHelper.USER_AGENT, forHTTPHeaderField: "User-Agent")
            if requestHeaders != nil {
                for (headerField, headerVal) in requestHeaders! {
                    request.setValue(headerVal, forHTTPHeaderField: headerField)
                }
            }
            
            if params != nil && request.httpMethod != "GET" {
                do  {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: [])
                } catch {
                    bfs.setError(HTTPHelper.assembleError(code: ApiErrorCode.parseRequestJSONError, errorMessage: nil))
                    return bfs.task
                }
            }
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                HTTPHelper.handleResponse(bfs: bfs, data: data as NSData?, response: response, error: error as NSError?)
            })
            task.resume()
            return bfs.task
        })
    }
    
    func baseHTTPGetRequest(url:String, params: [String: Any]?, requestHeaders: [String: String]?)->BFTask<AnyObject> {
        return baseHttpRequest(url: url, method: "GET", params: params, requestHeaders: requestHeaders)
    }
    
    
    func baseHTTPPostRequest(url:String, params: [String: Any]?, requestHeaders: [String: String])->BFTask<AnyObject> {
        return baseHttpRequest(url: url, method: "POST", params: params, requestHeaders: requestHeaders)
    }
    
    func baseHTTPPostRequest(url:String, params: [String: Any]?)->BFTask<AnyObject> {
        return baseHttpRequest(url: url, method: "POST", params: params, requestHeaders: nil)
    }
    
    func uploadAnalytics(with params:[String:Any]) {
        let url = HTTPHelper.prepareApiUrlForPath(path: "/stats")
        let _  = HTTPHelper.sharedInstance.baseHTTPPostRequest(url: url, params: params)
    }
    
    func uploadWeight(with params:[String:Any]) {
        let url = HTTPHelper.prepareApiUrlForPath(path: "/weight")
        let _ = HTTPHelper.sharedInstance.baseHTTPPostRequest(url: url, params: params)
    }
    
    // MARK: Singleton
    private override init() {
        super.init()
    }
    
    
    static var sharedInstance = HTTPHelper()
}
