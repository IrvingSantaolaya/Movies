//
//  Service.swift
//  Movies
//
//  Created by Irving Martinez on 2/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class Service {
    
    
    // MARK: - Properties
    
    // MARK: - Init
    let key = "4fec8a3c4a83c3497b4ee7956484463b"
    
    func fetchMovies() {
        
        let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(key)&language=en-US&page=1"
        guard let urlObject = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: urlObject) { (data, response, error) in
            
            if let error = error {
                print("There was an error with error: \(error)")
            }
            guard let data = data else { return }
            
            do {
                var movies = try JSONDecoder().decode([Movie].self, from: data)
                
                for movie in movies {
                    print(movie.title)
                }
                
            } catch {
                print("We got an error")
                
            }
            
        }.resume()
        
        
    }
       
    // MARK: - Helper Functions
}
