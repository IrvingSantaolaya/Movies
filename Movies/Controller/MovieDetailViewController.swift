//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Irving Martinez on 12/24/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - Properties
    var movie: Movie?
    var moviePoster: UIImage?
    let screenSize: CGRect = UIScreen.main.bounds
    
    // MARK: - Computed UI Properties
    
    // Main StackViews
    var mainStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.axis = .vertical
        stacker.distribution = .fillEqually
        stacker.spacing = 4
        return stacker
    }()
    
    var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    var middleView: UIView = {
        let view = UIView()
        return view
    }()

    var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var popularityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        
        // Setup Background
        backgroundImageView.image = moviePoster
        view.addSubview(backgroundImageView)
        backgroundImageView.anchorTo(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        backgroundImageView.addSubview(blurView)
        blurView.anchorTo(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        // Setup Stack and blurs
        blurView.contentView.addSubview(mainStackView)
        mainStackView.anchorTo(top: blurView.contentView.topAnchor, left: blurView.contentView.leftAnchor, bottom: blurView.contentView.bottomAnchor, right: blurView.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        mainStackView.addArrangedSubview(topView)
        mainStackView.addArrangedSubview(middleView)
        
        // Setup top content
        posterImageView.image = moviePoster
        topView.addSubview(posterImageView)
        posterImageView.anchorTo(top: topView.topAnchor, left: topView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: screenSize.width / 3, height: screenSize.width / 2)
        titleLabel.text = movie?.title
        topView.addSubview(titleLabel)
        titleLabel.anchorTo(top: topView.topAnchor, left: posterImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingBottom: 0, paddingRight: 0)
        
        guard let date = formatDate(date: movie!.release_date!) else { return }
        dateLabel.text = "Released on: \(date)"
        topView.addSubview(dateLabel)
        dateLabel.anchorTo(top: titleLabel.bottomAnchor, left: posterImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        
        guard let numberOfViews = movie?.popularity else { return }
        popularityLabel.text = "Number of views: \(numberOfViews * 1000)"
        topView.addSubview(popularityLabel)
        popularityLabel.anchorTo(top: dateLabel.bottomAnchor, left: posterImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        
        guard let rating = movie?.vote_average else { return }
        let emoji = ratingEmoji(rating: rating)
        ratingLabel.text = "Rating: \(emoji)\(rating)"
        topView.addSubview(ratingLabel)
        ratingLabel.anchorTo(top: popularityLabel.bottomAnchor, left: posterImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)
        
        // Setup middle content
        descriptionLabel.text = movie?.overview
        middleView.addSubview(descriptionLabel)
        descriptionLabel.anchorTo(top: middleView.topAnchor, left: middleView.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12)
    }
    
    // MARK: - Helper Methods
    private func ratingEmoji(rating: Double)-> String {
        var emoji = ""
        switch rating {
        case 8...10:
            emoji = "🤩"
        case 6...7.9:
            emoji = "🙂"
        case 5...5.9:
            emoji = "🥱"
        case 5...5.9:
            emoji = "🤢"
        default:
            emoji = "💩"
        }
        return emoji
    }
    
    private func formatDate(date: String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let formatDate = dateFormatter.date(from: date)

        dateFormatter.dateFormat = "MMM-DD-YYYY"
        guard let newDate = formatDate else { return nil }
        let goodDate = dateFormatter.string(from: newDate)
        return goodDate
    }
    
}
