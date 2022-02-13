//
//  SearchTableViewController.swift
//  WeatherForecast
//
//  Created by sole on 2022/02/13.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchCompleterResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        setUpTableView()
        setUpSearchCompleter()
    }
    
    private func setUpSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.placeholder = "도시 이름을 검색하세요."
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setUpTableView() {
        tableView.register(SearchListCell.nib(), forCellReuseIdentifier: SearchListCell.identifier)
    }
    
    private func setUpSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleterResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.identifier) as? SearchListCell else { return UITableViewCell() }
        let selectedItem = searchCompleterResults[indexPath.row]
        dump(selectedItem)
        cell.titleLabel.text = selectedItem.title
        return cell
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
