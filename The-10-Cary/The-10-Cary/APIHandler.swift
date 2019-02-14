//
//  APIHandler.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation
import UIKit

enum APIHandlerError: Error {
   case network(error: Error)
   case apiProvidedError(reason: String)
   case objectSerialization(reason: String)
   case imageError(reason: String)
}

class APIHandler {
   static let shared = APIHandler()
   private let apiKey = "9c4083e942f9fd119760a0bff9345b4b"

   func fetchMovies(from page: String?, completion: @escaping (Result<[Movie]>) -> Void) {
      REST.request(
         path: page ?? "https://api.themoviedb.org/3/movie/now_playing",
         method: "GET",
         parameters: ["api_key": apiKey],
         headers: nil) {

            (data, _, error) in
            guard error == nil else {
               completion(.failure(APIHandlerError.apiProvidedError(
                  reason: "Error calling GET on /movie/now_playing: \(error!)")))
               return
            }
            guard let data = data else {
               completion(.failure(APIHandlerError.objectSerialization(
                  reason: "Error: did not receive data from API")))
               return
            }

            do {
               let rootJSONObject = try JSONSerialization.jsonObject(with: data)

               guard let rootDictionary = rootJSONObject as? [String: Any],
                  let jsonArray = rootDictionary["results"] as? [[String:Any]] else {
                     completion(.failure(APIHandlerError.objectSerialization(
                        reason: "Error converting array to JSON")))
                     return
               }

               let movies = jsonArray.compactMap { Movie(json: $0) }
               completion(.success(movies))

            } catch {
               completion(.failure(APIHandlerError.objectSerialization(
                  reason: "Error converting data to JSON")))
            }
      }
   }

   func fetchConfig(from page: String?, completion: @escaping (Result<MovieDBConfig>) -> Void) {
      REST.request(
         path: page ?? "https://api.themoviedb.org/3/configuration",
         method: "GET",
         parameters: ["api_key": apiKey],
         headers: nil) {

            (data, _, error) in
            guard error == nil else {
               completion(.failure(APIHandlerError.apiProvidedError(
                  reason: "Error calling GET on /3/configuration: \(error!)")))
               return
            }
            guard let data = data else {
               completion(.failure(APIHandlerError.objectSerialization(
                  reason: "Error: did not receive data from API")))
               return
            }


            do {
               let rootJSONObject = try JSONSerialization.jsonObject(with: data)

               guard let rootDictionary = rootJSONObject as? [String: Any],
                  let jsonDictionary = rootDictionary["images"] as? [String: Any] else {
                     completion(.failure(APIHandlerError.objectSerialization(
                        reason: "Error converting root object to JSON")))
                     return
               }

               if let config = MovieDBConfig(json: jsonDictionary) {
                  completion(.success(config))
               }

            } catch {

               completion(.failure(APIHandlerError.objectSerialization(
                  reason: "Error converting data to JSON")))
            }
      }
   }

   func imageFrom(_ urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
      let session = URLSession.shared
      if let url = URL(string: urlString) {
         let request = URLRequest(url: url)
         let task = session.dataTask(with: request) {

            (data, response, error) in
            guard error == nil else {
               completion(nil, APIHandlerError.imageError(reason: "Error calling GET on \(urlString): \(error!)"))
               return
            }
            guard let data = data else {
               completion(nil, APIHandlerError.imageError(
                  reason: "Error: did not receive data"))
               return
            }
            if let image = UIImage(data: data) {
               completion(image, nil)
            }
         }
         task.resume()
      }
   }

   private func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
      guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
         return nil
      }
      let components = linkHeader.split(separator: ",")

      for item in components {
         let rangeOfNext = item.range(of: "rel=\"next\"", options: [])
         guard rangeOfNext != nil else {
            continue
         }
         let rangeOfPaddedURL = item.range(
            of: "<(.*)>;",
            options: .regularExpression,
            range: nil,
            locale: nil
         )
         guard let range = rangeOfPaddedURL else {
            return nil
         }
         let nextURL = item[range]
         let start = nextURL.index(range.lowerBound, offsetBy: 1)
         let end = nextURL.index(range.upperBound, offsetBy: -2)
         let trimmedRange = start..<end
         return String(nextURL[trimmedRange])
      }
      return nil
   }
}
