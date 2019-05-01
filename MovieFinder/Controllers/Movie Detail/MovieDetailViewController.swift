//
//  MovieDetailViewController.swift
//  MovieFinder
//
//  Created by Wassay Khan on 28/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import XCDYouTubeKit
import AVKit

class MovieDetailViewController: UIViewController {

	@IBOutlet weak var imgMovie: UIImageView!
	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var lbGenre: UILabel!
	@IBOutlet weak var lbDate: UILabel!
	@IBOutlet weak var lbOverview: UILabel!
	
	// variables and constants
	var movieID:Int?
	var arrMovieDetail:Array<MovieData> = []
	var movieVideoKey:String = ""
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getMovieDetail()
		self.getMovieVideoDetail()
        // Do any additional setup after loading the view.
    }

	fileprivate func getMovieDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString = KBaseUrl + KMovieDetail + "\(self.movieID!)?api_key=" + KAPIKey
			Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
				.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
					print("Progress: \(progress.fractionCompleted)")
				}
				.validate { request, response, data in
					// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
					return .success
				}
				.responseJSON { response in
					debugPrint(response)
					SVProgressHUD.dismiss()
					if	response.result.value == nil {
						let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						return
					}
					
					if response.response!.statusCode == 200 {
						
						print("Success")
						if let JSON:NSDictionary = response.result.value as! NSDictionary? {
							let movieDetail:MovieData = MovieData(movieDetail: JSON)
							self.imgMovie.sd_setImage(with: URL(string: (KImageBaseUrl + movieDetail.posterPath!)), placeholderImage: UIImage(named: ""))
							self.lbTitle.text = movieDetail.originalTitle
							self.lbDate.text = movieDetail.releaseDate
							self.lbOverview.text = movieDetail.overview
							var allGenre = ""
							for genre:Genre in movieDetail.genreArr {
								if allGenre == "" {
									allGenre += genre.name!
								}else{
									allGenre += ", " + genre.name!
								}
							}
							self.lbGenre.text = allGenre
							
						}
						
					}else if response.response!.statusCode == 401{
						
						print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KInvalidKey, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else if response.response!.statusCode == 404{
						
						print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KNoResourceFound, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else{
						
						//print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KUnknown, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}
					
			}
		}else{
			let alert = UIAlertController(title: "Network", message: KNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	fileprivate func getMovieVideoDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString = KBaseUrl + KMovieDetail + "\(self.movieID!)" + KMovieVideoDetail + "api_key=" + KAPIKey
			Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
				.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
					print("Progress: \(progress.fractionCompleted)")
				}
				.validate { request, response, data in
					// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
					return .success
				}
				.responseJSON { response in
					debugPrint(response)
					SVProgressHUD.dismiss()
					if	response.result.value == nil {
						let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						return
					}
					
					if response.response!.statusCode == 200 {
						
						print("Success")
						if let JSON:NSDictionary = response.result.value as! NSDictionary? {
							for dictionary in JSON["results"] as! NSArray{
								let job:MovieVideoDetail = MovieVideoDetail(dictionary: dictionary as! NSDictionary)
								self.movieVideoKey = job.videoKey!
								return
							}
							
						}
						
					}else if response.response!.statusCode == 401{
						
						print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KInvalidKey, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else if response.response!.statusCode == 404{
						
						print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KNoResourceFound, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else{
						
						//print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KUnknown, preferredStyle: UIAlertController.Style.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}
					
			}
		}else{
			let alert = UIAlertController(title: "Network", message: KNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	struct YouTubeVideoQuality {
		static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
		static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
		static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
	}
	
	
	@IBAction func btnWatchTrailerAction(_ sender: Any) {
		let playerViewController = AVPlayerViewController()
		self.present(playerViewController, animated: true, completion: nil)
		
		XCDYouTubeClient.default().getVideoWithIdentifier(self.movieVideoKey) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
			if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
				playerViewController?.player = AVPlayer(url: streamURL)
			} else {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
