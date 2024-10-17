//
//  PayTypeCell.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

final class PayTypeCell: UICollectionViewCell {
    private let screenWidth = UIScreen.main.bounds.width
    private var multiplierForView: CGFloat = 0
    
    private let payTypeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        return view
    }()
    
    private let payTypeBackImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private let payTypeNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        return label
    }()

    private let payTypeCodelabel: UILabel = {
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
        contentView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaLightGrayDark : UIColor.yaLightGrayLight
        }
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(payTypeBackImageView)
        payTypeBackImageView.addSubview(payTypeImageView)
        
        NSLayoutConstraint.activate([
            payTypeBackImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            payTypeBackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            payTypeBackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            payTypeBackImageView.widthAnchor.constraint(equalTo: payTypeBackImageView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            payTypeImageView.centerXAnchor.constraint(equalTo: payTypeBackImageView.centerXAnchor),
            payTypeImageView.centerYAnchor.constraint(equalTo: payTypeBackImageView.centerYAnchor)
        ])
        
        contentView.addSubview(payTypeNamelabel)
        
        NSLayoutConstraint.activate([
            payTypeNamelabel.leadingAnchor.constraint(equalTo: payTypeBackImageView.trailingAnchor, constant: 4),
            payTypeNamelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            payTypeNamelabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            payTypeNamelabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -7)
        ])
        
        contentView.addSubview(payTypeCodelabel)
        
        NSLayoutConstraint.activate([
            payTypeCodelabel.leadingAnchor.constraint(equalTo: payTypeNamelabel.leadingAnchor),
            payTypeCodelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            payTypeCodelabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            payTypeCodelabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 7)
        ])
    }
    
    func configure(with payType: PayType) {
        payTypeImageView.image = UIImage(named: payType.imageString)
        payTypeNamelabel.text = payType.name
        payTypeCodelabel.text = payType.code
        
    }
}
