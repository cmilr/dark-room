//
//  MovieDBConfig.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import Foundation

struct MovieDBConfig {
   var baseURL: String?
   var posterSizes: [String]?

   init() {
      self.baseURL = nil
      self.posterSizes = nil
   }

   init?(json: [String: Any]) {
      guard let baseURL = json["base_url"] as? String,
         let posterSizes = json["poster_sizes"] as? [String] else {
            print("Error: could not initialize properties")
            return nil
      }

      self.baseURL = baseURL
      self.posterSizes = posterSizes
   }
}
