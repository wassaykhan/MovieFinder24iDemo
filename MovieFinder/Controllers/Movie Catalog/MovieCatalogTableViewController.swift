//
//  MovieCatalogTableViewController.swift
//  MovieFinder
//
//  Created by Wassay Khan on 23/04/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage


class MovieCatalogTableViewController: UITableViewController {

	var arrMovies:Array<MovieData> = []
	var movieID:Int = 20
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getMoviesList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrMovies.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCatalogCellID", for: indexPath) as! MovieCatalogTableViewCell
		
        // Configure the cell...
		let data:MovieData = self.arrMovies[indexPath.row]
		if data.posterPath != nil {
			cell.imgMovie.sd_setImage(with: URL(string: (KImageBaseUrl + data.posterPath!)), placeholderImage: UIImage(named: ""))
		}
		
		cell.lbTitle.text = data.originalTitle

        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
