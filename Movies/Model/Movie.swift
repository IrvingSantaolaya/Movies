//
//  Movie.swift
//  Movies
//
//  Created by Irving Martinez on 2/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

struct Movie: Codable {
    
    // MARK: - Properties
    var title: String?
    var backdrop_path: String?
    var poster_path: String?
    var vote_average: Double?
    var description: String?
    
}
