//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit

final class NFTCollectionViewCell: UICollectionViewCell {
    static let identifier = "NFTCollectionViewCell"
    
    var onHeartButtonTapped: (() -> Void)?
    
    
    
    
    @objc private func heartButtonTapped() {
        onHeartButtonTapped?()
    }
    
    func configure(with nft: NFT) {
        
    }
}
