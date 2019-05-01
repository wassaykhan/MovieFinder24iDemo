//
//  MovieCatalogViewController.swift
//  MovieFinder
//
//  Created by Wassay Khan on 29/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage



class MovieCatalogViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
	
	

	var arrMovies:Array<MovieData> = []
	var movieID:Int = 20
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.searchBar.delegate = self
		self.hideKeyboard()
		self.getMoviesList()
        // Do any additional setup after loading the view.
    }
	
	
	fileprivate func getMoviesList() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString = KBaseUrl + KPopularMovies + "api_key=" + KAPIKey
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
							self.arrMovies = []
							for dictionary in JSON["results"] as! NSArray{
								let job:MovieData = MovieData(dictionary: dictionary as! NSDictionary)
								self.arrMovies.append(job)
							}
							//self.isLoadingList = false
							self.tableView.reloadData()
							
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
	
	// MARK: - Table view data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrMovies.count
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCatalogCellID", for: indexPath) as! MovieCatalogTableViewCell
		
		// Configure the cell...
		let data:MovieData = self.arrMovies[indexPath.row]
		if data.posterPath != nil {
			cell.imgMovie.sd_setImage(with: URL(string: (KImageBaseUrl + data.posterPath!)), placeholderImage: UIImage(named: ""))
		}
		
		cell.lbTitle.text = data.originalTitle
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print("searchText \(String(describing: searchBar.text))")
		if searchBar.text != "" {
			let filteredArray = arrMovies.filter() { (($0.originalTitle?.contains(searchBar.text!))!) }
			print(filteredArray)
			self.arrMovies = []
			self.arrMovies = filteredArray
			self.hideKeyboard()
			view.endEditing(true)
			self.tableView.reloadData()
		}
		
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "movieDetailIdentifier") {
			let indexPath = self.tableView!.indexPathForSelectedRow!
			let idMovie = self.arrMovies[indexPath.row]
			self.movieID = idMovie.movieId!
			let viewController = segue.destination as! MovieDetailViewController
			viewController.movieID = self.movieID
		}
	}

}


extension UIViewController{
	func hideKeyboard()
	{
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(UIViewController.dismissKeyboard))
		
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard()
	{
		view.endEditing(true)
	}
}

extension String {
	
	func contains(_ find: String) -> Bool{
		return self.range(of: find) != nil
	}
	
	func containsIgnoringCase(_ find: String) -> Bool{
		return self.range(of: find, options: .caseInsensitive) != nil
	}
}
