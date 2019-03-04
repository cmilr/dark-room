//
//  APIHandler.swift
//  DarkRoom
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

enum BaseURL: String {
   case nowPlaying = "https://api.themoviedb.org/3/movie/now_playing"
   case upcoming = "https://api.themoviedb.org/3/movie/upcoming"
}

class NetworkManager {
   static let shared = NetworkManager()
   private var basePosterURL: String?
   private var posterSizes: [String]?

   func fetchMovies(from baseURL: BaseURL, completion: @escaping (Result<[Movie]>) -> Void) {
      fetchMovieDBConfig() {
         RESTful.request(
            path: baseURL.rawValue,
            method: "GET",
            parameters: ["api_key": apiKey, "region" : "US"],
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

                  var movies = [Movie]()
                  for (index, jsonData) in jsonArray.enumerated() where index < 10 {
                     if var movie = Movie(json: jsonData) {
                        movie.composedPosterPath = self.composePosterPath(for: movie)
                        movies.append(movie)
                     }
                  }
                  completion(.success(movies))

               } catch {
                  completion(.failure(APIHandlerError.objectSerialization(
                     reason: "Error converting data to JSON")))
               }
         }
      }
   }

   func fetchMovieDBConfig(completion: @escaping (() -> Void)) {
      RESTful.request(
         path: "https://api.themoviedb.org/3/configuration",
         method: "GET",
         parameters: ["api_key": apiKey],
         headers: nil) {

            (data, _, error) in
            guard error == nil else {
               print("Error calling GET on /3/configuration: \(error!)")
               completion()
               return
            }
            guard let data = data else {
               print("Error: did not receive data from API")
               completion()
               return
            }

            do {
               let rootJSONObject = try JSONSerialization.jsonObject(with: data)

               guard let rootDictionary = rootJSONObject as? [String: Any],
                  let json = rootDictionary["images"] as? [String: Any] else {
                     print("Error converting root object to JSON")
                     completion()
                     return
               }

               if let baseURL = json["base_url"] as? String,
                  let posterSizes = json["poster_sizes"] as? [String] {
                  self.basePosterURL = baseURL
                  self.posterSizes = posterSizes
                  completion()
               }

            } catch {
               print("Error converting data to JSON")
               completion()
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

    private func composePosterPath(for movie: Movie) -> String? {
        let screenWidth = UIScreen.main.bounds.width
        var posterSizeIndex = 0

        switch true {
        case screenWidth <= 342:
            posterSizeIndex = 3
        case screenWidth <= 500:
            posterSizeIndex = 4
        case screenWidth <= 780:
            posterSizeIndex = 5
        default:
            posterSizeIndex = 4
        }

        guard
            let size = posterSizes?[posterSizeIndex],
            let baseURL = basePosterURL,
            let posterPath = movie.posterPath else {
                return nil
        }

        var urlString = baseURL + size + posterPath
        let insertIndex = urlString.index(urlString.startIndex, offsetBy: 4)
        urlString.insert(Character("s"), at: insertIndex)
        return urlString
    }
   
}
