//
//  NewsCollectionViewController.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 21.02.2024.
//

import UIKit

class NewsCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! 
//    {
//        didSet {
//            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
//    }
    
    // MARK: - Private Properties
    var source: Source?
    private var articles: [Article] = []
    
    private let networkManager = NetworkingService.shared
    private var spinnerView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(in: view)
        title = source?.name
        fetchNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        detailVC.article = articles[indexPath.row]
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .red
        spinnerView.startAnimating()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as? NewsCell else { 
            return UICollectionViewCell()
        }
    
        // Configure the cell
        //cell.maxWidth = collectionView.bounds.width - 20
        //cell.maxHeight = 0.6*UIScreen.main.bounds.height
        print(indexPath.row)
        cell.configure(article: articles[indexPath.row])
    
        return cell
    }

    // MARK: UICollectionViewDelegate
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

}
// MARK: - UICollectionViewDelegateFlowLayout
extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: UIScreen.main.bounds.width, height: 554)
    }
}

// MARK: - Networking
extension NewsCollectionViewController {
    private func fetchNews() {
        let url = Link.newsBySourceURL.rawValue + (source?.id ?? "") + "&apiKey=" + Link.apiKey.rawValue
        
        networkManager.fetchData(Article.self, from: url) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.collectionView.reloadData()
                self?.spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
