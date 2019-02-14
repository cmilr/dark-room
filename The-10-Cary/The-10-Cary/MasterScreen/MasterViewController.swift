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
   var movies = [Movie]()
   var config = MovieDBConfig()
   var imageCache = [String: UIImage?]()

   override func viewDidLoad() {
      super.viewDidLoad()
      collectionView.dataSource = self
      collectionView.delegate = self
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      loadConfig()
      loadMovies(urlToLoad: nil)
   }

   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      configureLayout()
   }

   private func loadConfig() {
      APIHandler.shared.fetchConfig(from: nil) {
         (result) in

         guard result.error == nil else {
            print(result.error!)
            return
         }
         guard let configuration = result.value else {
            print("Error: no configuration was fetched")
            return
         }
         self.config = configuration
         print(self.config)

         DispatchQueue.main.async {
            self.collectionView.reloadData()
         }
      }

   }

   private func loadMovies(urlToLoad: String?) {
      APIHandler.shared.fetchMovies(from: urlToLoad) {
         (result) in

         guard result.error == nil else {
            print(result.error!)
            return
         }
         guard let fetchedMovies = result.value else {
            print("Error: no movies were fetched")
            return
         }
         if urlToLoad == nil {
            self.movies = []
         }
         self.movies += fetchedMovies

         DispatchQueue.main.async {
            self.collectionView.reloadData()
         }
      }
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
      return movies.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

      let movie = movies[indexPath.row]
      cell.movieTitleLabel.text = movie.title
      cell.movieImageView.image = nil

      if let size = config.posterSizes?.first {
//         let urlString = config.baseURL! + size + movie.posterPath!
         let urlString = "https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg"
         print(urlString)
         if let cachedImage = imageCache[urlString] {
            cell.movieImageView.image = cachedImage
         } else {
            APIHandler.shared.imageFrom(urlString) {
               (image, error) in
               guard error == nil else {
                  print(error!)
                  return
               }
               self.imageCache[urlString] = image
               DispatchQueue.main.async { [weak self] in
                  if let cellToUpdate = self?.collectionView.cellForItem(at: indexPath) as? MovieCell {
                     cellToUpdate.movieImageView.transition(toImage: image)
                     cellToUpdate.setNeedsLayout()
                  }
               }
            }
         }
      }

      return cell
   }
}

extension MasterViewController: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("Movie #\(indexPath.item)")
   }
}
