import Foundation
import UIKit
import Kingfisher

protocol CartItemCellDelegate: AnyObject {
    func didTapButton(in cell: CartItemCell)
}

final class CartItemCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let cellIdentifier = "CartItemCell"
    
    weak var delegate: CartItemCellDelegate?
    
    // MARK: - Private Properties
    private var nftID: String = ""
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.red.cgColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private lazy var raitingView: StarRatingView = {
        let view = StarRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private lazy var costCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: CartViewController.Constants.deleteNftIcon), for: .normal)
        button.tintColor = UIColor.dynamicBlack
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func deleteButtonTapped(_ sender: UIButton) {
        delegate?.didTapButton(in: self)
    }
    
    // MARK: - Public Methods
    func configure(with nft: Nft, stubImage: UIImage? = UIImage()) {
        if let imageUrl = nft.images.first {
            nftImageView.kf.setImage(with: imageUrl, placeholder: stubImage)
        } else {
            nftImageView.image = stubImage
        }
        nftID = nft.id
        nftNameLabel.text = nft.name
        raitingView.rating = nft.rating
        costLabel.text = CartViewController.Constants.costString
        costCounterLabel.text = "\(String(format: "%.2f", nft.price)) ETH"
    }
    
    func getNftID() -> String {
        nftID
    }

    // MARK: - Private Methods
    private func setupView() {
        contentView.addSubview(nftImageView)

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor)
        ])
        
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40 * ScreenSizeHelper.getViewMultiplier()),
            deleteButton.heightAnchor.constraint(equalToConstant: 40 * ScreenSizeHelper.getViewMultiplier())
        ])
        
        contentView.addSubview(nftNameLabel)

        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nftNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor),
            nftNameLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24)
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
}
