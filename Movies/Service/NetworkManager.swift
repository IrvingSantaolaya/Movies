//
//  NetworkManager.swift
//  Movies
//
//  Created by Irving Martinez on 12/23/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // URL properties
    let nowPlayingString = "now_playing?api_key=\(Constants.key)&language=en-US&page="
    
    // Fetch request and return movies or error
    func fetchMovies(withPageNumber pageNum: String, completion: @escaping([Movie]?,Error?)-> Void) {
        
        // Grab json data
        guard let url = URL(string: Constants.baseUrlString + nowPlayingString + pageNum) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(String(decoding: data, as: UTF8.self))
            // Decode json data
            do {
                let movies = try JSONDecoder().decode(Movies.self, from: data)
                // Return movies array
                DispatchQueue.main.async {
                    completion(movies.results, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func fetchMoviePoster(urlString: String, completion: @escaping(Data?, Error?)-> Void) {
        // Create url object
        let url = URL(string: urlString)
        // Check it's not nil
        guard url != nil else {
            print("Could not create url object")
            return
        }
        // Create the session
        let session = URLSession.shared
        // Create the dataTask
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            // Check for errors
            if let data = data, error == nil {
                // Save data to cache
                CacheManager.saveImageData(urlString, data)
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }
        dataTask.resume()
    }
    
}
