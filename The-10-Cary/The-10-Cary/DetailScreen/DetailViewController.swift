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
   @IBOutlet weak var overviewLabel: UILabel!
   var movie = Movie()

   override func viewDidLoad() {
      super.viewDidLoad()
      configureOverviewLabel()
   }

   override func viewDidLayoutSubviews() {
      configureGradientView()
   }

   private func configureOverviewLabel() {
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
