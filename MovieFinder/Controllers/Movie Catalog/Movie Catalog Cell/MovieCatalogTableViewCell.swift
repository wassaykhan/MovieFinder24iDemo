//
//  MovieCatalogTableViewCell.swift
//  MovieFinder
//
//  Created by Wassay Khan on 23/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class MovieCatalogTableViewCell: UITableViewCell {

	@IBOutlet weak var imgMovie: UIImageView!
	@IBOutlet weak var lbTitle: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
