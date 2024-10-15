//  Created by Artem Morozov on 15.10.2024.


import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CollectionViewCell"
    
    private lazy var cellImage = UIImageView()
    private lazy var starRatingView = StarRatingView()
    private lazy var nameLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var cartButton = UIButton()
    
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
        self.backgroundColor = .gray
        configureCellImage()
    }
    
    func configureCellImage() {
        cellImage.contentMode = .scaleAspectFill
        cellImage.image = UIImage(named: "nftStubImage")
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
