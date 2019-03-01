//
//  APIHandler.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation
import UIKit

enum MoviedbAPIManagerError: Error {
   case network(error: Error)
   case apiProvidedError(reason: String)
   case objectSerialization(reason: String)
   case imageError(reason: String)
}

class APIHandler {
   static let sharedInstance = APIHandler()
   private let apiKey = "9c4083e942f9fd119760a0bff9345b4b"

   func fetchPublicMovies(pageToLoad: String?, completion: @escaping (Result<[Movie]>, String?) -> Void) {
      REST.request(
         path: pageToLoad ?? "https://api.themoviedb.org/3/movie/now_playing",
         method: "GET",
         parameters: ["api_key": apiKey],
         headers: nil) {

            (data, response, error) in
            guard error == nil else {
               completion(.failure(MoviedbAPIManagerError.apiProvidedError(
                  reason: "Error calling GET on /gists/public: \(error!)")), nil)
               return
            }
            guard let data = data else {
               completion(.failure(MoviedbAPIManagerError.objectSerialization(
                  reason: "Error: did not receive data from API")), nil)
               return
            }
            guard let response = response as? HTTPURLResponse else {
               completion(.failure(MoviedbAPIManagerError.objectSerialization(
                  reason: "Error: did not receive response from API")), nil)
               return
            }

            do {
               if let jsonMessage = try JSONSerialization.jsonObject(
                  with: data, options: []) as? [String:Any] {
                  let errorString = jsonMessage.reduce("") { "\($1.key): \($1.value) | " + $0 }
                  completion(.failure(MoviedbAPIManagerError.apiProvidedError(reason: errorString)), nil)
                  return
               }
               guard let jsonArray = try JSONSerialization.jsonObject(
                  with: data, options: []) as? [[String:Any]] else {
                     completion(.failure(MoviedbAPIManagerError.objectSerialization(
                        reason: "Error converting array to JSON")), nil)
                     return
               }

               let gists = jsonArray.compactMap { Movie(json: $0) }
               let next = self.parseNextPageFromHeaders(response: response)
               completion(.success(gists), next)

            } catch {
               completion(.failure(MoviedbAPIManagerError.objectSerialization(
                  reason: "Error converting data to JSON")), nil)
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
               completion(nil, MoviedbAPIManagerError.imageError(reason: "Error calling GET on \(urlString): \(error!)"))
               return
            }
            guard let data = data else {
               completion(nil, MoviedbAPIManagerError.imageError(
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
