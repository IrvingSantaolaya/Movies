//
//  CurrentMovieCell.swift
//  Movies
//
//  Created by Irving Martinez on 2/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class CurrentMovieCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var movieCellImageView: UIImageView!
    @IBOutlet weak var movieCellBlurr: UIVisualEffectView!
    @IBOutlet weak var movieCellLabel: UILabel!
    var movieToDisplay: Movie?
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        configureCellUI()
    }
    
    // MARK - Helper Functions
    func configureCellUI() {
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
    }
    
}
