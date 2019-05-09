//
//  ViewController.swift
//  DarkRoom
//
//  Created by Cary Miller on 2/13/19.
//  Copyright © 2019 C.Miller & Co. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    @IBOutlet weak var swipeImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var betterSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var collectionViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var betterSegmentedControlYConstraint: NSLayoutConstraint!

    var imageCache = [String: UIImage?]()
    var nowPlayingMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var movies = [Movie]()
    var currentCell = 0
    var nowPlaying = true
    var switchingCategories = false
    var dataBeingRefreshed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configureNewSegmentedControl()
        loadMovies(into: &movies)
        showSwipeImageIfNeeded()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerCurrentCell()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
        configureGradient()
        collectionView.flashScrollIndicators()
    }

    @objc func willEnterForeground() {
        nowPlaying = true
        loadMovies(into: &nowPlayingMovies)
        if self.movies.count > 0 {
            collectionView.scrollToItem(
                at: IndexPath(row: 0, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
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

    @IBAction func didChooseBetterMovieType(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
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

                if self.switchingCategories, self.movies.count > 0 {
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

    private func loadImage(for movie: Movie, into cell: MovieCell, at indexPath: IndexPath) {
        guard let urlString = movie.composedPosterPath else {
            return
        }
        if let cachedImage = imageCache[urlString] {
            cell.movieImageView.image = cachedImage
            if !dataBeingRefreshed {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        } else {
            NetworkManager.shared.imageFrom(urlString) { (image, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                self.imageCache[urlString] = image
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if !self.dataBeingRefreshed {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                    if movie == self.movies[indexPath.row] {
                        cell.movieImageView.transition(toImage: image)
                    }
                }
            }
        }
    }

    private func configureLayout() {
        var widthOffset: CGFloat = 40.0
        var heightOffset: CGFloat = 20.0
        var leftSectionInset: CGFloat = 20.00
        var rightSectionInset: CGFloat = 20.00

        if UIScreen.main.bounds.height >= DeviceHeight.iPhoneX {
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
        let colorOne = CGColor.custom(.purple)
        let colorTwo = CGColor.custom(.purpleDark)
        let gradient = CAGradientLayer(start: .topLeft, end: .bottomRight, colors: [colorOne, colorTwo], type: .axial)
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func configureNewSegmentedControl() {
        betterSegmentedControl.segments = LabelSegment.segments(
            withTitles: ["Now Playing", "Coming Soon"]
        )
        if UIScreen.main.bounds.height >= DeviceHeight.iPhoneX {
            betterSegmentedControlYConstraint.constant = 40
        }
    }

    private func showSwipeImageIfNeeded() {
        let swipeAlreadyShown = UserDefaults.standard.bool(forKey: "swipeShown")
        if !swipeAlreadyShown {
            swipeImageView.isHidden = false
            swipeImageView.fadeIn(1.25, delay: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.swipeImageView.fadeOut(1.25, delay: 0)
            }
            UserDefaults.standard.set(true, forKey: "swipeShown")
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
        cell.configure(with: movie)
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
        let reloadDistance = CGFloat(-70.0)
        if collectionView.contentOffset.x < reloadDistance {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            dataBeingRefreshed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                self.loadMovies(into: &self.movies)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.dataBeingRefreshed = false
            }
        }
    }
}
