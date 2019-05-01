//
//  MovieVideoDetail.swift
//  MovieFinder
//
//  Created by Wassay Khan on 29/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class MovieVideoDetail: NSObject {
	var videoId:Int?
	var videoKey:String?
	
	init(dictionary:NSDictionary) {
		self.videoId = dictionary["id"] as? Int
		self.videoKey = dictionary["key"] as? String
	}
}
