//
//  DetailViewController.swift
//  DarkRoom
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
        setPoster()
        configureBackButton()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        setOverview()
    }

    @objc func willEnterBackground() {
        dismiss(animated: false, completion: nil)
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
            overviewTextView.formatAndDisplay(
                text: overview,
                withFont: "System Font Regular",
                fontSize: 20,
                fontColor: UIColor.custom(.purpleLight),
                lineHeight: 1.3,
                kerning: 0,
                alignment: .left,
                indicatorStyle: .white
            )
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

    private func configureBackButton() {
        backButtonImageView.tintColorDidChange()
    }

    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
