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
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   var moviedbConfig = MovieDBConfig()
   var imageCache = [String: UIImage?]()
   var movies = [Movie]()
   var nowPlaying = true

   override func viewDidLoad() {
      super.viewDidLoad()
      collectionView.dataSource = self
      collectionView.delegate = self
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      loadConfig()
      loadMovies()
      configureSegmentedControl()
   }

   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      configureLayout()
      configureGradientView()
   }

   private func configureGradientView() {
      if let colorOne = UIColor(named: "moviePurple")?.cgColor,
         let colorTwo = UIColor(named: "movieDarkPurple")?.cgColor {
         let gradient = CAGradientLayer(start: .topLeft, end: .bottomRight, colors: [colorOne, colorTwo], type: .axial)
         gradient.frame = view.bounds
         view.layer.insertSublayer(gradient, at: 0)
      }
   }

   @IBAction func didChooseMovieType(_ sender: UISegmentedControl) {
      if sender.selectedSegmentIndex == 0 {
         nowPlaying = true
      } else {
         nowPlaying = false
      }
      loadMovies()
   }

   private func loadConfig() {
      NetworkManager.shared.fetchConfig(from: nil) {
         (result) in

         guard result.error == nil else {
            print(result.error!)
            return
         }
         guard let configuration = result.value else {
            print("Error: no configuration was fetched")
            return
         }
         self.moviedbConfig = configuration
      }
   }

   private func loadMovies() {
      let baseURL = nowPlaying ? BaseURL.nowPlaying : BaseURL.upcoming
      NetworkManager.shared.fetchMovies(from: baseURL) {
         (result) in

         guard result.error == nil else {
            print(result.error!)
            return
         }
         guard let fetchedMovies = result.value else {
            print("Error: no movies were fetched")
            return
         }
         self.movies = fetchedMovies

         DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.movies.count > 0 {
               self.collectionView.scrollToItem(
                  at: IndexPath(row: 0, section: 0),
                  at: .centeredHorizontally,
                  animated: false
               )
            }
         }
      }
   }

   private func configureLayout() {
      if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         flowLayout.itemSize = CGSize(
            width: collectionView.bounds.width - CGFloat(40.0),
            height: collectionView.bounds.height - CGFloat(20.0)
         )
         flowLayout.minimumLineSpacing = CGFloat(20.0)
      }
   }

   private func configureSegmentedControl() {
      let font = UIFont.boldSystemFont(ofSize: 18)
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
      segmentedControl.layer.cornerRadius = 0.0
   }

   private func loadImage(for movie: Movie, into cell: MovieCell) {
      let screenWidth = UIScreen.main.bounds.width
      var posterSizeIndex = 0

      switch true {
      case screenWidth <= 342:
         posterSizeIndex = 3
      case screenWidth <= 500:
         posterSizeIndex = 4
      case screenWidth <= 780:
         posterSizeIndex = 5
      default:
         posterSizeIndex = 4
      }

      guard let size = moviedbConfig.posterSizes?[posterSizeIndex],
         let baseURL = moviedbConfig.baseURL,
         let posterPath = movie.posterPath else {
            return
      }

      var urlString = baseURL + size + posterPath
      let insertIndex = urlString.index(urlString.startIndex, offsetBy: 4)
      urlString.insert(Character("s"), at: insertIndex)

      if let cachedImage = imageCache[urlString] {
         cell.movieImageView.image = cachedImage
      } else {
         NetworkManager.shared.imageFrom(urlString) { (image, error) in
            guard error == nil else {
               print(error!)
               return
            }
            self.imageCache[urlString] = image
            DispatchQueue.main.async { [] in
               cell.movieImageView.transition(toImage: image)
            }
         }
      }
   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showMovieDetail"{
         if let detailPage = segue.destination as? DetailViewController,
            let selectedCell = sender as? MovieCell,
               let indexPath = collectionView?.indexPath(for: selectedCell) {
            let movie = movies[indexPath.row]
            detailPage.movie = movie
         }
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
      loadImage(for: movie, into: cell)

      return cell
   }
}

extension MasterViewController: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("Movie #\(indexPath.item)")
   }
}
