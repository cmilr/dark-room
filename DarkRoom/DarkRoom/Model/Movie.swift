//
//  Movie.swift
//  DarkRoom
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation

struct Movie {
   var id: Int?
   var title: String?
   var overview: String?
   var posterPath: String?
   var composedPosterPath: String?
   var voteAverage: Double?
   var genreIDs: [Int]?
   var runtime: Int?

   init() {
      self.id = nil
      self.title = nil
      self.overview = nil
      self.posterPath = nil
      self.composedPosterPath = nil
      self.voteAverage = nil
      self.genreIDs = nil
      self.runtime = nil
   }

   init?(json: [String: Any]) {
      guard let id = json["id"] as? Int,
         let title = json["title"] as? String,
         let overview = json["overview"] as? String else {
            return nil
      }

      self.id = id
      self.title = title
      self.overview = overview
      self.composedPosterPath = nil
      self.runtime = nil

      if let voteAverage = json["vote_average"] as? Double {
         self.voteAverage = voteAverage
      }

      if let genreIDs = json["genre_ids"] as? [Int] {
         self.genreIDs = genreIDs
      } 

      if let posterPath = json["poster_path"] as? String {
         self.posterPath = posterPath
      }
   }
}
