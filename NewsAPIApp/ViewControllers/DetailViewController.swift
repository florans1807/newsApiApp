//
//  DetailViewController.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 18.02.2024.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var foodImageView: UIImageView!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: article)
    }
    
    // MARK: - Private Methodds
    func updateUI(with article: Article) {
        guard let url = URL(string: article.urlToImage ?? "") else { return }
        foodImageView.af.setImage(withURL: url)
    }
}
