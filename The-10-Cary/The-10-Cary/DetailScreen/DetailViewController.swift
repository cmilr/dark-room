//
//  DetailViewController.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/14/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

   @IBOutlet weak var gradientView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var ratingsLabel: UILabel!
   @IBOutlet weak var genreLabel: UILabel!
   @IBOutlet weak var overviewLabel: UILabel!
   @IBOutlet weak var posterImageView: UIImageView!

   var movie = Movie()

   override func viewDidLoad() {
      super.viewDidLoad()
      setTitleLabel()
      setRating()
      setGenres()
      setOverviewLabel()
   }

   override func viewDidLayoutSubviews() {
      configureGradientView()
   }

   private func setTitleLabel() {
      titleLabel.text = movie.title
   }

   private func setRating() {
      if let rawAverage = movie.voteAverage {
         let average = (rawAverage / 2).rounded()
         let ratingString = String( Array(repeating: "★", count: Int(average)) )
         ratingsLabel.text = ratingString
      }
   }

   private func setGenres() {
      if let genres = movie.genreIDs {
         var genreString = ""
         for genre in genres {
            if let genreTitle = genreDict[genre] {
               genreString += "\(genreTitle), "
            }
         }
         genreString = String(genreString.dropLast(2))
         genreLabel.text = genreString
      }
   }

   private func setOverviewLabel() {
      if let overview = movie.overview {
         overviewLabel.text = overview
         overviewLabel.setLineHeight(1.5)
      }
   }

   private func configureGradientView() {
      if let colorOne = UIColor(named: "moviePurple")?.cgColor,
         let colorTwo = UIColor(named: "movieDarkPurple")?.cgColor {
         let gradient = CAGradientLayer(start: .topLeft, end: .bottomRight, colors: [colorOne, colorTwo], type: .axial)
         gradient.frame = gradientView.bounds
         gradientView.layer.insertSublayer(gradient, at: 0)
      }
   }
}
