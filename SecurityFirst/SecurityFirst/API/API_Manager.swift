//
//  API_Manager.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 06/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import KeychainSwift
import SwiftyJSON

class APIManager {
    
    
    static let sharedInstance: APIManager = APIManager()
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("logo.png")
        
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }

    private init() {
        self.manager = Alamofire.SessionManager()
    }
    
    static let baseURL = "https://dev.people.com.ai/mobile/api/v2/"
    
    private let manager: Alamofire.SessionManager!
    
    private let keychain = KeychainSwift()

    private var headers: HTTPHeaders = [
        "Authorization": "",
        "Accept": "application/json"
    ]
    
    enum Endpoint: String {
        case signIn = "login"
        case signUp = "register"
        case logo = "logo/%@"
    }
    
        func request(_ method          : Alamofire.HTTPMethod,
                     _ endpoint        : Endpoint,
                     _ pathParamenters : [CVarArg]?,
                     _ parameters      : [String:Any]?,
                     handler: @escaping ((_ status: Bool, _ message: String)->Void)) {
        
        
        var requestURL = APIManager.baseURL + endpoint.rawValue
        
        if pathParamenters != nil && (pathParamenters?.count)! > 0 {
            requestURL = String.init(format: requestURL, arguments: pathParamenters!)
        }
        
        let encoding: ParameterEncoding = JSONEncoding.default
        
        if endpoint.rawValue == Endpoint.logo.rawValue {
            headers["Authorization"] = keychain.get("token")
        }
         self.manager.request(requestURL, method: method, parameters: parameters, encoding: encoding, headers: headers).rx.responseJSON()
            .subscribe(
                onNext: {
                    self.handleResponse(endpoint, JSON($0))
                    let message = self.keychain.get("message") ?? ""
                    if message == "OK" {
                        handler(true, message)
                    } else {
                        handler(false, message)
                    }
                
            })
       
    }
    func download(_ pathParamenters : [CVarArg]?,
                  handler: @escaping ((_ status: Bool, _ URL: Data, _ message: String)->Void)) {
        var requestURL = APIManager.baseURL + Endpoint.logo.rawValue
        if pathParamenters != nil && (pathParamenters?.count)! > 0 {
            requestURL = String.init(format: requestURL, arguments: pathParamenters!)
        }
        
        let encoding: ParameterEncoding = JSONEncoding.default
        
        headers["Authorization"] = keychain.get("token")
        self.manager.download(requestURL, method: .get, parameters: nil, encoding: encoding, headers: headers, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.result.value {
                    handler(true, data, "OK")
                }
                handler(false, Data(), "error")
            }
        }
    
  
    func handleResponse( _ endpoint : Endpoint,
                         _ json     : JSON) {
        if let token = json["token"].string {
            switch endpoint {
            case .signIn:
                keychain.set(token, forKey: "token")
            case .signUp:
                keychain.set(token, forKey: "token")
            default:
                print("Endpoint do not support handleResponse")
            }
            keychain.set("OK", forKey: "message")
        } else if var message = json["message"].string {
            switch endpoint {
            case .signIn:
                message = "Login: \(message)"
            case .signUp:
                message = "Registro: \(message)"
            default:
                print("Endpoint do not support handleResponse")
            }
            keychain.set(message, forKey: "message")
        }
        
    }
    
    
    
}

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    
    func responseJSON() -> Observable<Any> {
        return Observable.create { observer in
            let request = self.base.responseJSON { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: request.cancel)
        }
    }
}



