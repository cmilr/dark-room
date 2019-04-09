//
//  RESTful.swift
//  DarkRoom
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation

class RESTful {
    
    public static func request(path: String, method: String, parameters: [String:String]?, headers: [String:String]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard var components = URLComponents(string: path) else {
            print("Error: could not create URL components")
            return
        }
        
        // GET: parameters = Query string parameters
        if method == "GET", let parameters = parameters {
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        var request = URLRequest(url: components.url!)
        
        // POST or PUT: parameters = Request body parameters
        if method == "POST" || method == "PUT" {
            if let parameters = parameters {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error)
                }
            }
        }
        
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
//        Log.networkInfo(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
    }
}
