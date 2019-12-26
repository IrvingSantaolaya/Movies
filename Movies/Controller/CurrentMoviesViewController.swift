//
//  ViewController.swift
//  Movies
//
//  Created by Irving Martinez on 12/23/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class CurrentMoviesViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var currentMovieCollectionView: UICollectionView!
    var movies = [Movie]()
    var pageNumber = 1
    var prefetchBarrier = 4
    var dataLoading = false
    let networkManager = NetworkManager()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        initialFetch()
    }
    
    // MARK: - Helper Functions
    func updateUI() {
        currentMovieCollectionView.delegate = self
        currentMovieCollectionView.dataSource = self
    }
    
    func initialFetch() {
        dataLoading = true
        networkManager.fetchMovies(withPageNumber: String(pageNumber)) { (movies, error) in
            guard let movies = movies, error == nil else {
                self.dataLoading = false
                #warning("SHOW ALERT")
                return
            }
            self.dataLoading = false
            self.movies.append(contentsOf: movies)
            self.currentMovieCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionView Delegate/ Datasource Methods
extension CurrentMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CurrentMovieCell
        let movie = movies[indexPath.item]
        displayMovie(movie, cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == movies.count - 1 ) {
            dataLoading = true
            networkManager.fetchMovies(withPageNumber: String(pageNumber)) { (movies, error) in
                if self.pageNumber < 60 {
                    self.pageNumber += 1
                }
                guard let movies = movies, error == nil else {
                    #warning("SHOW ALERT")
                    return
                }
                self.movies.append(contentsOf: movies)
                let indexPathsToReload = self.calculateIndexPathsToReload(from: movies)
                self.onFetchCompleted(with: indexPathsToReload)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        guard let posterPath = selectedMovie.poster_path else { return }
        guard let posterData = CacheManager.retrieveImageData(Constants.cellBasePath + posterPath) else { return }
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movie = selectedMovie
        movieDetailVC.moviePoster = UIImage(data: posterData)
        
        present(movieDetailVC, animated: true, completion: nil)
    }
}

// MARK: - CollectionView Helpers
extension CurrentMoviesViewController {
    
    func displayMovie(_ movie: Movie, cell: CurrentMovieCell) {
        // Set the label and imageView to invisible
        cell.movieCellLabel.alpha = 0
        cell.movieCellImageView.alpha = 0
        
        // Fade in label
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            cell.movieCellLabel.alpha = 1
        }, completion: nil)
        
        // Clear the imageview in case the cell is being reused and reassign
        cell.movieCellImageView.image = nil
        cell.movieToDisplay = movie
        cell.movieCellLabel.text = cell.movieToDisplay?.title
        
        if cell.movieToDisplay?.poster_path == nil {
            return
        }
        
        // Check cache manager
        let urlString = Constants.cellBasePath + cell.movieToDisplay!.poster_path!
        let cachedData = CacheManager.retrieveImageData(urlString)
        
        if cachedData != nil {
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
                // Fade in image
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                cell.movieCellImageView.alpha = 1
            }, completion: nil)
        }
    }
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(item: $0, section: 0) }
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = currentMovieCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            currentMovieCollectionView.isHidden = false
            currentMovieCollectionView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        currentMovieCollectionView.reloadItems(at: indexPathsToReload)
    }
}


