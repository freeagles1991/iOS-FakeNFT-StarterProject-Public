//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit

final class NFTTableViewCell: UITableViewCell {
    static let identifier = "NFTCell"
    
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
        label.numberOfLines = 2
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private let raitingView: StarRatingView = {
        let view = StarRatingView()
        return view
    }()
    
    private let autorLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular13
        label.textColor = UIColor.segmentActive
        label.text = "Цена"
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with nft: Nft) {
        nameLabel.text = nft.name
        autorLabel.text = "от \(nft.author)"
        priceValueLabel.text = "\(nft.price) ETH"
        raitingView.rating = nft.rating
        if let imageUrl = nft.images.first {
            nftImageView.kf.setImage(with: imageUrl)
        }
    }
    
    @objc
    private func likeButtonTapped() {
        let isActive = likeButton.currentImage == UIImage(named: "heartIsActive")
        
        if isActive {
            likeButton.setImage(UIImage(named: "headrtNoActive"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heartIsActive"), for: .normal)
        }
    }
    
    private func setupUI() {
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(raitingView)
        nameStackView.addArrangedSubview(autorLabel)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(nameStackView)
        contentView.addSubview(priceStackView)
        
        [nftImageView, likeButton, nameStackView, priceStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
                nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                nftImageView.widthAnchor.constraint(equalToConstant: 108),
                nftImageView.heightAnchor.constraint(equalToConstant: 108),
                
                likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
                likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
                likeButton.widthAnchor.constraint(equalToConstant: 40),
                likeButton.heightAnchor.constraint(equalToConstant: 40),
                
                nameStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
                nameStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                nameStackView.trailingAnchor.constraint(lessThanOrEqualTo: priceStackView.leadingAnchor, constant: -39),
                
                priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
                priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                priceStackView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
