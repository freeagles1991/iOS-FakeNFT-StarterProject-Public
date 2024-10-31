//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit

protocol NFTCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(in cell: NFTCollectionViewCell)
}

final class NFTCollectionViewCell: UICollectionViewCell {
    static let identifier = "NFTCollectionViewCell"
    
    weak var delegate: NFTCollectionViewCellDelegate?
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "headrtNoActive"), for: .normal)
        button.addTarget(nil, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.numberOfLines = 1
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private let ratingView: StarRatingView = {
        let view = StarRatingView()
        return view
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .regular15
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with nft: Nft, isLiked: Bool) {
        let shortName = nft.name.split(separator: " ").first.map(String.init)
        nameLabel.text = shortName
        priceValueLabel.text = "\(nft.price) ETH"
        ratingView.rating = nft.rating
        if let imageUrl = nft.images.first {
            nftImageView.kf.setImage(with: imageUrl)
        }
        
        let likeImageName = isLiked ? "heartIsActive" : "headrtNoActive"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }
    
    //MARK: - Private Methods0
    @objc
    private func likeButtonTapped() {
        delegate?.didTapLikeButton(in: self)
    }
    
    private func setupUI() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(infoContainerView)
        
        infoContainerView.addSubview(nameLabel)
        infoContainerView.addSubview(ratingView)
        infoContainerView.addSubview(priceValueLabel)
        
        [nftImageView, likeButton, infoContainerView, nameLabel, ratingView,priceValueLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            infoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoContainerView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            infoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            nameLabel.topAnchor.constraint(equalTo: infoContainerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: -4),
            ratingView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -8),
            
            priceValueLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8),
            priceValueLabel.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            priceValueLabel.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor)
            
        ])
    }
}
