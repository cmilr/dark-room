//
//  Movie.swift
//  The-10-Cary
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
   var backdropPath: String?

   init() {
      self.id = nil
      self.title = nil
      self.overview = nil
      self.posterPath = nil
      self.backdropPath = nil
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

      if let posterPath = json["poster_path"] as? String,
         let backdropPath = json["backdrop_path"] as? String {
         self.posterPath = posterPath
         self.backdropPath = backdropPath
      }
   }
}
