//
//  SearchTableViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit
import MapKit

final class LocationSearchTableViewController: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchCompleterResults = [MKLocalSearchCompletion]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailInSearch" else { return }
        let detailViewController = segue.destination as? DetailViewController
        if let coordinate = sender as? CLLocation {
            let coordinate = Coordinate(longitude: coordinate.coordinate.longitude, latitude: coordinate.coordinate.latitude)
            detailViewController?.coord = coordinate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpSearchCompleter()
    }
    
    private func setUpSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.placeholder = "지역명을 검색하세요."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setUpSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleterResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = searchCompleterResults[indexPath.row].title
        let rangeArray = searchCompleterResults[indexPath.row].titleHighlightRanges
        cell.textLabel?.attributedText = title.convertToNSMutableAttributedString(ranges: rangeArray, fontSize: 18, fontWeight: .semibold, fontColor: UIColor.white.cgColor)
        return cell
        
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = searchCompleterResults[indexPath.row]
        let request = MKLocalSearch.Request(completion: selectedData)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("noresponse Error: \(String(describing: error?.localizedDescription))")
                return
            }
            for item in response.mapItems {
                if let location = item.placemark.location {
                    self.performSegue(withIdentifier: "showDetailInSearch", sender: location)
                }
            }
        }
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        searchCompleter.queryFragment = searchBarText
        if searchController.searchBar.text?.count == 0 {
            searchCompleterResults = []
            tableView.reloadData()
        }
    }
}

extension LocationSearchTableViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompleterResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}
