//
//  ViewController.swift
//  The-10-Cary
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var segmentedControl: UISegmentedControl!
   @IBOutlet weak var collectionViewYConstraint: NSLayoutConstraint!
   @IBOutlet weak var segmentedControlYConstraint: NSLayoutConstraint!
   var imageCache = [String: UIImage?]()
   var nowPlayingMovies = [Movie]()
   var upcomingMovies = [Movie]()
   var movies = [Movie]()
   var currentCell = 0
   var nowPlaying = true
   var switchingCategories = false

   override func viewDidLoad() {
      super.viewDidLoad()
      collectionView.dataSource = self
      collectionView.delegate = self
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      loadMovies(into: &movies)
      centerCurrentCell()
   }

   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      configureLayout()
      configureGradient()
      configureSegmentedControl()
   }

   private func centerCurrentCell() {
      if self.movies.count > 0 {
         collectionView.scrollToItem(
            at: IndexPath(row: currentCell, section: 0),
            at: .centeredHorizontally,
            animated: false
         )
      }
   }

   @IBAction func didChooseMovieType(_ sender: UISegmentedControl) {
      if sender.selectedSegmentIndex == 0 {
         nowPlaying = true
         loadMovies(into: &nowPlayingMovies)
      } else {
         nowPlaying = false
         loadMovies(into: &upcomingMovies)
      }
      switchingCategories = true
   }

   private func loadMovies(into movies: inout [Movie]) {
      activityIndicator.startAnimating()
      activityIndicator.isHidden = false
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
            if self.movies.count > 0, self.switchingCategories {
               self.collectionView.scrollToItem(
                  at: IndexPath(row: 0, section: 0),
                  at: .centeredHorizontally,
                  animated: false
               )
               self.switchingCategories = false
            }
         }
      }
   }

   private func configureLayout() {
      // Default offset settings
      var widthOffset: CGFloat = 40.0
      var heightOffset: CGFloat = 20.0
      var leftSectionInset: CGFloat = 20.00
      var rightSectionInset: CGFloat = 20.00

      // If device is iPhone X or taller, zero-out all offsets to allow
      // contentView cell to center and make use of taller screen.
      if UIScreen.main.bounds.height >= 812 {
         widthOffset = 0
         heightOffset = 0
         leftSectionInset = 0
         rightSectionInset = 0
         collectionViewYConstraint.constant = 50
      }

      if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         flowLayout.itemSize = CGSize(
            width: collectionView.bounds.width - widthOffset,
            height: collectionView.bounds.height - heightOffset
         )
         flowLayout.minimumLineSpacing = CGFloat(20.0)
         flowLayout.sectionInset.left = leftSectionInset
         flowLayout.sectionInset.right = rightSectionInset
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

   private func configureSegmentedControl() {
      let font = UIFont.boldSystemFont(ofSize: 18)
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
      segmentedControl.layer.cornerRadius = 0.0
      if UIScreen.main.bounds.height >= 812 {
         segmentedControlYConstraint.constant = 50
      }
   }

   private func loadImage(for movie: Movie, into cell: MovieCell, at indexPath: IndexPath) {
      guard let urlString = movie.composedPosterPath else {
         return
      }
      if let cachedImage = imageCache[urlString] {
         cell.movieImageView.image = cachedImage
         self.activityIndicator.stopAnimating()
         self.activityIndicator.isHidden = true
      } else {
         NetworkManager.shared.imageFrom(urlString) { (image, error) in
            guard error == nil else {
               print(error!)
               return
            }
            self.imageCache[urlString] = image
            DispatchQueue.main.async { [] in
               self.activityIndicator.stopAnimating()
               self.activityIndicator.isHidden = true
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
            detailPage.imageCache = imageCache
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
      cell.movieImageView.image = UIImage(named: "image-placeholder")
      cell.configure()
      loadImage(for: movie, into: cell, at: indexPath)

      return cell
   }
}

extension MasterViewController: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      currentCell = indexPath.row
   }

   // Custom refresh control for horizontal UICollectionViews.
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let reloadDistance = CGFloat(-75.0)
      if collectionView.contentOffset.x < reloadDistance {
         loadMovies(into: &movies)
      }
   }
}
