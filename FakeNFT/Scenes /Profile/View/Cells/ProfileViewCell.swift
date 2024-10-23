//
//  ProfileViewCell.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 12.10.2024.
//

import UIKit

final class ProfileViewCell: UITableViewCell {
    static let identifier = "ProfileCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold17
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accessoryImageView: UIImageView = {
        let largeConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: largeConfig)
        imageView.tintColor = .segmentActive
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(accessoryImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 12),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func configure(with title: String, count: Int?) {
        if let count = count, count > 0 {
            titleLabel.text = "\(title) (\(count))"
        } else {
            titleLabel.text = title
        }
    }

}
