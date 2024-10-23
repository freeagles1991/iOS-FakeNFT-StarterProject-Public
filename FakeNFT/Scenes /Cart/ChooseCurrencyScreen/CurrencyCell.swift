//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

final class CurrencyCell: UICollectionViewCell {
    static let reuseIdentifier =  "CurrencyItemCell"
    
    private let screenWidth = UIScreen.main.bounds.width
    private var multiplierForView: CGFloat = 0
    
    private let currencyImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let currencyBackImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private let currencyNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = UIColor.dynamicBlack
        return label
    }()

    private let currencyCodelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = UIColor.yaGreenUniversal
        return label
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
        contentView.backgroundColor = UIColor.dynamicLightGray
        
        contentView.layer.borderColor = UIColor.dynamicBlack.cgColor
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(currencyBackImageView)
        currencyBackImageView.addSubview(currencyImageView)
        
        NSLayoutConstraint.activate([
            currencyBackImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            currencyBackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyBackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            currencyBackImageView.widthAnchor.constraint(equalTo: currencyBackImageView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            currencyImageView.centerXAnchor.constraint(equalTo: currencyBackImageView.centerXAnchor),
            currencyImageView.centerYAnchor.constraint(equalTo: currencyBackImageView.centerYAnchor),
            currencyImageView.widthAnchor.constraint(equalTo: currencyBackImageView.widthAnchor),
            currencyImageView.heightAnchor.constraint(equalTo: currencyBackImageView.heightAnchor)
        ])
        
        contentView.addSubview(currencyNamelabel)
        
        NSLayoutConstraint.activate([
            currencyNamelabel.leadingAnchor.constraint(equalTo: currencyBackImageView.trailingAnchor, constant: 4),
            currencyNamelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            currencyNamelabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            currencyNamelabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -7)
        ])
        
        contentView.addSubview(currencyCodelabel)
        
        NSLayoutConstraint.activate([
            currencyCodelabel.leadingAnchor.constraint(equalTo: currencyNamelabel.leadingAnchor),
            currencyCodelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            currencyCodelabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            currencyCodelabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 7)
        ])
    }
    
    func configure(with currency: Currency) {
        currencyImageView.kf.setImage(with: URL(string: currency.image))
        currencyNamelabel.text = currency.title
        currencyCodelabel.text = currency.name
    }
    
    func toggleSelectState(_ isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? 1.0 : 0
    }
}
