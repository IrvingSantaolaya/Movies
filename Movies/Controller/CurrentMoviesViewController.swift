//
//  ViewController.swift
//  Movies
//
//  Created by Irving Martinez on 2/24/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class CurrentMoviesViewController: UIViewController {

    // MARK - Properties
    @IBOutlet weak var currentMovieCollectionView: UICollectionView!
    var movies = [Movie]()
    var pageNumber = 1
    var dataLoading = false
    let networkManager = NetworkManager()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        networkCall()
    }

        // MARK - Helper Functions

    func updateUI() {
        currentMovieCollectionView.delegate = self
        currentMovieCollectionView.dataSource = self
    }
    
    func networkCall() {
        networkManager.fetchMovies(withPageNumber: String(pageNumber)) { (movies, error) in
            guard let movies = movies, error == nil else {
                #warning("ALERT MESSAGE")
                return
            }
            self.movies.append(contentsOf: movies)
            self.currentMovieCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionView Delegate/ Datasource
extension CurrentMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CurrentMovieCell
        
        self.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? CurrentMovieCell else { return }
        let movie = movies[indexPath.item]

//        if indexPath.row == movies.count - 2 {
//            
//            while pageNumber < 10 {
//                pageNumber += 1
//                networkManager.fetchMovies(withPageNumber: String(pageNumber)) { (movies, error) in
//                    guard let movies = movies, error == nil else {
//                        #warning("SHOW ALERT")
//                        return
//                    }
//                    self.movies.append(contentsOf: movies)
//                    print(self.movies.count)
//                    collectionView.reloadData()
//                }
//            }
//            
//        }
        displayMovie(movie, cell: cell)
    }
    
}

// MARK: - Networking
extension CurrentMoviesViewController {
    
    func displayMovie(_ movie: Movie, cell: CurrentMovieCell) {
        
        // Set the label and imageView to invisible
        cell.movieCellLabel.alpha = 0
        cell.movieCellImageView.alpha = 0
        
        // Fade in label
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            
            cell.movieCellLabel.alpha = 1
            
        }, completion: nil)
        
        // Clear the imageview in case the cell is being reused
        cell.movieCellImageView.image = nil
        
        // Hold the reference to the movie
        cell.movieToDisplay = movie
        
        // Display the title
        cell.movieCellLabel.text = cell.movieToDisplay?.title
        
        // Check if movie has an image
        
        if cell.movieToDisplay?.poster_path == nil {
            
            return
        }
        
        let urlString = Constants.cellBasePath + cell.movieToDisplay!.poster_path!
        // Check if the image is stored inside cache using urlString
        let cachedData = CacheManager.retrieveImageData(urlString)
        
        if cachedData != nil {
            // If the cached data exists then use it instead
            cell.movieCellImageView.image = UIImage(data: cachedData!)
            
            // Fade in image
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                
                cell.movieCellImageView.alpha = 1
                
            }, completion: nil)
            return
        }
        // Else fetch image
        networkManager.fetchMoviePoster(urlString: urlString) { (data, error) in
            guard let data = data, error == nil else {
                #warning("SHOW ALERT")
                return
            }
            
            cell.movieCellImageView.image = UIImage(data: data)
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                cell.movieCellImageView.alpha = 1
            }, completion: nil)
            
        }
        
    }
    
}


