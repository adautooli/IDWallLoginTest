//
//  ApiLayer.swift
//  IdWallLogin
//
//  Created by Adauto Oliveira on 24/04/22.
//

import Foundation

public enum HTTP: String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}

open class ApiLayer {
    
     var URL_BASE: String?
     var urlComponents: URLComponents?
     var customHeader: [[String:String]] = []
    
    public init (URL_BASE: String?) {
        if URL_BASE != nil {
            self.URL_BASE = URL_BASE
        } else {
            self.URL_BASE = ParamsServices.url
        }
    }
    
    func customizeHeader(customHeader: [[String:String]]) {
        self.customHeader = customHeader
    }
    
    
    public func callApi(Method: HTTP,endpoint: String, postData: Data?, query: [URLQueryItem]?, completion: @escaping (Data?,Error?) -> Void){
        DispatchQueue.main.async { [self] in
            self.urlComponents = URLComponents(url: URL(string: self.URL_BASE!)!, resolvingAgainstBaseURL: false)
            
            if (query != nil)  {
                self.urlComponents?.queryItems = query
            }
            
            self.urlComponents!.path = "\(self.urlComponents!.path)\(endpoint)"
            var request: URLRequest = URLRequest(url: self.urlComponents!.url!, timeoutInterval: Double.infinity)
            
            request.httpMethod = Method.rawValue
            
            var defaultHeader = ["Content-Type" : "application/json"]
            
            for cHeader in self.customHeader {
                request.setValue("\(cHeader.first?.value ?? "")", forHTTPHeaderField: "\(cHeader.first?.key ?? "")")
                defaultHeader.removeValue(forKey: "\(cHeader.first?.key ?? "")")
            }
            
            for dHeader in defaultHeader {
                request.setValue("\(dHeader.value)", forHTTPHeaderField: "\(dHeader.key)")
            }
            
            if (postData != nil) {
                request.httpBody = postData
            }
            
            let session = URLSession(configuration: .ephemeral)
            let task = session.dataTask(with: request) { data, response, error in
                if (error != nil) {
                    completion(nil, error)
                }else {
                    guard let data = data else {return}
                    completion(data, nil)
                }
            }
            task.resume()
            
        }
    }
}
