//
//  MovieCell.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {

   @IBOutlet weak var movieImageView: UIImageView!
   @IBOutlet weak var movieTitleLabel: UILabel!
   @IBOutlet weak var movieTitleLabelYConstraint: NSLayoutConstraint!

   func configure() {
      if UIScreen.main.bounds.height >= 812 {
         movieTitleLabelYConstraint.constant = -30
      }
   }
}
