//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Дима on 11.10.2024.
//

import Foundation
import UIKit
import Kingfisher

final class CartItemCell: UICollectionViewCell {
    private let screenWidth = UIScreen.main.bounds.width
    private var multiplierForView: CGFloat = 0
    
    private let nftImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.red.cgColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = .black
        return label
    }()
    
    private let raitingView: StarRatingView = {
        let view = StarRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = .black
        return label
    }()
    
    private let costCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = .black
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: CartViewController.Constants.deleteNftIcon), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        multiplierForView = screenWidth / 375.0
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(nftImageView)

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor)
        ])
        
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40 * multiplierForView),
            deleteButton.heightAnchor.constraint(equalToConstant: 40 * multiplierForView)
        ])
        
        contentView.addSubview(nftNameLabel)

        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nftNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24) // New bottom constraint to ensure vertical position
        ])
        
        contentView.addSubview(raitingView)
        NSLayoutConstraint.activate([
            raitingView.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor,constant: -4),
            raitingView.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4)
        ])
        
        contentView.addSubview(costCounterLabel)
        NSLayoutConstraint.activate([
            costCounterLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            costCounterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            costCounterLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor),
            costCounterLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 24)
        ])
        
        contentView.addSubview(costLabel)
        NSLayoutConstraint.activate([
            costLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            costLabel.bottomAnchor.constraint(equalTo: costCounterLabel.topAnchor, constant: -2),
            costLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor),
            costLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 24)
        ])

    }

    func configure(with nft: Nft, stubImage: UIImage? = UIImage()) {
        if let imageUrl = nft.images.first {
            nftImageView.kf.setImage(with: imageUrl, placeholder: stubImage)
        } else {
            nftImageView.image = stubImage
        }
        nftNameLabel.text = nft.name
        raitingView.rating = nft.rating
        print(raitingView.rating, nft.rating)
        costLabel.text = CartViewController.Constants.costString
        costCounterLabel.text = "\(String(format: "%.2f", nft.price)) ETH"
    }
}
