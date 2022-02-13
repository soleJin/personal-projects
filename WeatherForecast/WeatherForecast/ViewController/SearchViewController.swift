//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/11.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
    }
    

}

//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        <#code#>
//    }
//}
//
//extension SearchViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        <#code#>
//    }
//}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        return cell
    }
    
    
}
