//  Created by Artem Morozov on 15.10.2024.


import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CollectionViewCell"
    
    private lazy var cellImage = UIImageView()
    private lazy var starRatingView = StarRatingView()
    private lazy var nameLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var labelsStackView = UIStackView()
    private lazy var cartButton = UIButton()
    private lazy var likeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellWidth = contentView.frame.width
        
        NSLayoutConstraint.activate([
            cellImage.heightAnchor.constraint(equalToConstant: cellWidth)
        ])
    }
}

//MARK: Configure UI

private extension CollectionViewCell {
    func configureUI() {
        configureCellImage()
        configureLikeButton()
        configureStarRatingView()
        configureLabelsStackView()
        configureCartButtonAndStackView()
    }
    
    func configureCellImage() {
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
        cellImage.layer.cornerRadius = 12
        cellImage.image = UIImage(named: "nftImageMock")
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configureLikeButton() {
        likeButton.setImage(UIImage(named: "heartIsActive"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(likeButtonDidTapped), for: .touchUpInside)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func likeButtonDidTapped() {
        
    }
    
    func configureStarRatingView() {
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starRatingView)
        starRatingView.rating = 3
        
        NSLayoutConstraint.activate([
            starRatingView.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: 8),
            starRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configureLabelsStackView() {
        nameLabel.text = "Carmine Wooten"
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.segmentActive
        nameLabel.font = UIFont.bold17
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        
        currencyLabel.text = "1 ETH"
        currencyLabel.textAlignment = .left
        currencyLabel.textColor = UIColor.segmentActive
        currencyLabel.font = UIFont.medium10
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(currencyLabel)
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .fill
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 4
    }
    
    func configureCartButtonAndStackView() {
        cartButton.setImage(UIImage(named: "deleteNftIcon"), for: .normal)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addTarget(self, action: #selector(cartButtonDidTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, cartButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func cartButtonDidTapped() {
        
    }
}
