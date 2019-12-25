//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Irving Martinez on 12/24/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie?
    var moviePoster: UIImage?
    
    // Computed UI Properties
    var backgroundImageView: UIImageView {
        let imageView = UIImageView()
        return imageView
    }
    
    var posterImageView: UIImageView {
        let imageView = UIImageView()
        return imageView
    }
    
    var titleLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    var descriptionLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
    
    var blurView: UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
    }
    
    
}
