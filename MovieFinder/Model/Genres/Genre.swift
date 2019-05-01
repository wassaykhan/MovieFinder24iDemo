//
//  Genre.swift
//  MovieFinder
//
//  Created by Wassay Khan on 28/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Genre: NSObject {
	
	var genreId:Int?
	var name:String?
	
	init(dictionary:NSDictionary) {
		self.genreId = dictionary["id"] as? Int
		self.name = dictionary["name"] as? String
	}

}
