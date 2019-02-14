//
//  ViewController.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

   @IBOutlet weak var collectionView: UICollectionView!
   var previousCellPosition = CGFloat.leastNormalMagnitude

   override func viewDidLoad() {
      super.viewDidLoad()
      collectionView.dataSource = self
      collectionView.delegate = self
   }

   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      configureLayout()
   }

   private func configureLayout() {
      if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         flowLayout.itemSize = CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
         )
         flowLayout.minimumLineSpacing = CGFloat(20.0)
      }
   }
}

extension MasterViewController: UICollectionViewDataSource {

   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 10
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
      cell.movieTitleLabel.text = String(indexPath.row + 1)
      cell.movieImageView.image = UIImage(named: "Zissou")
      return cell
   }
}

extension MasterViewController: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print(indexPath.item)
   }
}
