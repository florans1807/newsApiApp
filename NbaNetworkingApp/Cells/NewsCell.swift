//
//  NewsCell.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 21.02.2024.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView! {
        didSet {
            newsImageView.layer.cornerRadius = 20.0
        }
    }
//    @IBOutlet private var maxWidthOfStackViewConstraint: NSLayoutConstraint! {
//         didSet {
//             //maxWidthOfStackViewConstraint.isActive = false
//         }
//     }
//    
//    @IBOutlet private var maxHeightOfStackViewConstraint: NSLayoutConstraint! {
//         didSet {
//             //maxHeightOfStackViewConstraint.isActive = false
//         }
//     }
    
    // MARK: - Private Properties
    private let networkManager = NetworkingService.shared
    private var spinnerView = UIActivityIndicatorView()
//    var maxWidth: CGFloat? = nil {
//         didSet {
//             guard let maxWidth = maxWidth else {
//                 return
//             }
//             maxWidthOfStackViewConstraint.isActive = true
//             maxWidthOfStackViewConstraint.constant = maxWidth
//         }
//     }
//    
//    var maxHeight: CGFloat? = nil {
//        didSet {
//            guard let maxHeight = maxHeight else {
//                return
//            }
//            maxHeightOfStackViewConstraint.isActive = true
//            maxHeightOfStackViewConstraint.constant = maxHeight
//        }
//    }
    
    private var imageURL: URL? {
        didSet {
            print(newsImageView.image ?? "no image")
            newsImageView.image = nil
            updateImage()
        }
    }
    
    //Configure cell
    func configure(article: Article) {
        showSpinner(in: contentView)
        descriptionLabel.text = article.descriptionInfo
        print(article.urlToImage ?? "no url")
        imageURL = URL(string: article.urlToImage ?? "")
    }
    
    // MARK: - Private Methods
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .white
        spinnerView.startAnimating()
        spinnerView.center = newsImageView.center
        spinnerView.hidesWhenStopped = true
        contentView.addSubview(spinnerView)
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        getImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                if imageURL == self?.imageURL {
                    self?.newsImageView.image = image
                    self?.spinnerView.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        //Get image from cache
        if let cachedImage = ImageCacheManager.shared.object(forKey: url.lastPathComponent as NSString) {
            print("Image from cache: ", url.lastPathComponent)
            completion(.success(cachedImage))
            return
        }
        
        //Download from url
        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                ImageCacheManager.shared.setObject(image, forKey: url.lastPathComponent as NSString)
                print("Image from network: ", url.lastPathComponent)
                completion(.success(image))
            case .failure(let error):
                print(error)
            }
        }
    }
}
