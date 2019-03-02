//
//  MovieCell.swift
//  DarkRoom
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {

   @IBOutlet weak var movieImageView: UIImageView!
   @IBOutlet weak var movieTitleLabel: UILabel!
   @IBOutlet weak var movieTitleLabelYConstraint: NSLayoutConstraint!

   func configure(with movie: Movie) {
      movieTitleLabel.text = movie.title
      movieImageView.image = UIImage(named: "image-placeholder")

      if UIScreen.main.bounds.height >= DeviceHeight.iPhoneX {
         movieTitleLabelYConstraint.constant = -30
         movieTitleLabel.numberOfLines = 2
      }
   }
}
