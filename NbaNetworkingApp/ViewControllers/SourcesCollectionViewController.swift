//
//  SourcesCollectionViewController.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 20.02.2024.
//

import UIKit

final class SourcesCollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    private var sources: [Source] = []
    private var filteredSources: [Source] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    private let networkManager = NetworkingService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //Fetch Data From Api
        fetchSources()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filteredSources.count : sources.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard 
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sourceCell", for: indexPath) as? SourceCell
        else {
            return UICollectionViewCell()
        }
        
        var source: Source
        
        if isFiltering {
            source = filteredSources[indexPath.row]
        } else {
            source = sources[indexPath.row]
        }
        
        // Configure the cell
        cell.configure(sourceName: source.name)
    
        return cell
    }

    // MARK: UICollectionViewDelegate
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.
//    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newsVC = segue.destination as? NewsCollectionViewController else { return }
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        
        newsVC.source = isFiltering ? filteredSources[indexPath.row] : sources[indexPath.row]
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SourcesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - UISearchResultsUpdating
extension SourcesCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredSources = sources.filter({ (source: Source) -> Bool in
            return source.name.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
}

// MARK: - Networking
extension SourcesCollectionViewController {
    private func fetchSources() {
        networkManager.fetchData(Source.self, from: Link.allSourcesURL.rawValue) { result in
            switch result {
            case .success(let sources):
                self.sources = sources
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
