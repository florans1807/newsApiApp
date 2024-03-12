//
//  SourceCell.swift
//  NbaNetworkingApp
//
//  Created by Флоранс on 20.02.2024.
//

import UIKit

class SourceCell: UICollectionViewCell {
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    func configure(sourceName: String) {
        sourceLabel.text = sourceName
    }
}
