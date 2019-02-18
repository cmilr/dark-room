//
//  DetailViewController.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/14/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var ratingsLabel: UILabel!
   @IBOutlet weak var genreLabel: UILabel!
   @IBOutlet weak var overviewTextView: UITextView!
   @IBOutlet weak var posterImageView: UIImageView!
   @IBOutlet weak var backButtonImageView: UIImageView!

   var movie = Movie()
   var imageCache = [String: UIImage?]()

   override func viewDidLoad() {
      super.viewDidLoad()
      setTitleLabel()
      setRating()
      setGenres()
      setOverview()
      setPoster()
      configureBackButton()
   }

   override func viewDidLayoutSubviews() {
      configureGradient()
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

   private func setOverview() {
      if let overview = movie.overview {
         let adjustedFontSize = CGFloat(18.0)
         let adjustedLineSpacing = CGFloat(10.0)

         // Configure font style.
         let font = "System Font Regular"
         let fontColor = UIColor.white

         // Configure paragraph style.
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineSpacing = adjustedLineSpacing
         paragraphStyle.alignment = .left
         paragraphStyle.lineBreakMode = .byWordWrapping

         // Apply font and paragraph styles.
         let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont(name: font, size: adjustedFontSize)!,
            NSAttributedString.Key.foregroundColor: fontColor
         ]
         overviewTextView.attributedText = NSAttributedString(string: overview , attributes: attributes)

         overviewTextView.indicatorStyle = .white
         overviewTextView.scrollIndicatorInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.overviewTextView.flashScrollIndicators()
         }
      }
   }

   private func setPoster() {
      guard let urlString = movie.composedPosterPath else {
         return
      }
      if let cachedImage = imageCache[urlString] {
         posterImageView.image = cachedImage
      } else {
         NetworkManager.shared.imageFrom(urlString) { (image, error) in
            guard error == nil else {
               print(error!)
               return
            }
            self.imageCache[urlString] = image
            DispatchQueue.main.async { [] in
               self.posterImageView.transition(toImage: image)
            }
         }
      }
   }

   private func configureGradient() {
      if let colorOne = UIColor(named: "moviePurple")?.cgColor,
         let colorTwo = UIColor(named: "movieDarkPurple")?.cgColor {
         let gradient = CAGradientLayer(start: .topLeft, end: .bottomRight, colors: [colorOne, colorTwo], type: .axial)
         gradient.frame = view.bounds
         view.layer.insertSublayer(gradient, at: 0)
      }
   }

   private func configureBackButton() {
      backButtonImageView.tintColorDidChange()
   }

   @IBAction func dismissViewController(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
}
