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
    
    private init() {
        self.manager = Alamofire.SessionManager()
    }
    
    static let BASE_URL = "https://dev.people.com.ai/mobile/api/v2/"
    
    private let manager: Alamofire.SessionManager!
    
    private let keychain = KeychainSwift()

    private var headers: HTTPHeaders = [
        "Authorization": "",
        "Accept": "application/json"
    ]
    
    enum Endpoint: String {
        case SignIn = "login"
        case SignUp = "register"
        case Logo = "logo/%@"
    }
    
        func request(_ method          : Alamofire.HTTPMethod,
                     _ endpoint        : Endpoint,
                     _ pathParamenters : [CVarArg]?,
                     _ parameters      : [String:Any]? ) {
        
        
        var requestURL = APIManager.BASE_URL + endpoint.rawValue
        
        if pathParamenters != nil && (pathParamenters?.count)! > 0 {
            requestURL = String.init(format: requestURL, arguments: pathParamenters!)
        }
        
        let encoding: ParameterEncoding = JSONEncoding.default
        
        if endpoint.rawValue == Endpoint.Logo.rawValue {
            headers["Authorization"] = keychain.get("token")
        }
        self.manager.request(requestURL, method: method, parameters: parameters, encoding: encoding, headers: headers).rx.responseJSON()
            .subscribe(
                onNext: {
                    self.handleResponse(endpoint, JSON($0))
                },onError: {
                    self.handleError(endpoint, JSON($0))
                    
                }
            )
            
       
    }
    
    func handleError(    _ endpoint : Endpoint,
                         _ json     : JSON) {
        switch endpoint {
            case .SignIn:
                print(json["message"].string!)
                //Show Alert With Message Error in Endpoint
            case .SignUp:
                print(json["message"].string!)
                //Show Alert With Message Error in Endpoint
            default:
                print(json["message"].string!)
                //Show Alert With Message Error Generic
        }
        
    }
    
    func handleResponse( _ endpoint : Endpoint,
                         _ json     : JSON) {
        switch endpoint {
            case .SignIn:
                keychain.set(json["token"].string!, forKey: "token")
            case .SignUp:
                keychain.set(json["token"].string!, forKey: "token")
            default:
                print("Endpoint do not support handleResponse")
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
                    observer.onError(error)
                }
            }
            
            return Disposables.create(with: request.cancel)
        }
    }
}



