//
//  MovieData.swift
//  MovieFinder
//
//  Created by Wassay Khan on 27/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class MovieData: NSObject {
	var movieId:Int?
	var title:String?
	var posterPath:String?
	var originalTitle:String?
	var adult:Bool?
	var overview:String?
	var releaseDate:String?
	var budget:Int?
	var homepage:String?
	var popularity:Int?
	var genreArr: Array<Genre> = []
	
	init(dictionary:NSDictionary) {
		self.movieId = dictionary["id"] as? Int
		self.title = dictionary["title"] as? String
		self.posterPath = dictionary["poster_path"] as? String
		self.originalTitle = dictionary["original_title"] as? String
		self.adult = dictionary["adult"] as? Bool
		self.overview = dictionary["overview"] as? String
		self.releaseDate = dictionary["release_date"] as? String
		self.budget = dictionary["budget"] as? Int
		self.homepage = dictionary["homepage"] as? String
		self.popularity = dictionary["popularity"] as? Int
	}
	
	init(movieDetail:NSDictionary) {
		self.originalTitle = movieDetail["original_title"] as? String
		self.overview = movieDetail["overview"] as? String
		self.posterPath = movieDetail["poster_path"] as? String
		self.releaseDate = movieDetail["release_date"] as? String
		//Getting all the items from Order
		self.genreArr = []
		for dict in movieDetail["genres"] as! NSArray{
			let genre:Genre = Genre(dictionary: dict as! NSDictionary)
			self.genreArr.append(genre)
		}

	}
	
}
