//  Created by Artem Morozov on 14.10.2024.


import UIKit

final class CatalogTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CatalogTableViewCell"
    
    private lazy var cellImageView = UIImageView()
    private lazy var cellLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(urlForDownloadImage: URL, header: String) {
        
    }
}

//MARK: Configure UI

private extension CatalogTableViewCell {
    func configureUI() {
        configureImageView()
        configureCellLabel()
    }
    
    func configureImageView() {
        cellImageView.clipsToBounds = true
        cellImageView.layer.cornerRadius = 12
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellImageView)
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func configureCellLabel() {
        cellLabel.text = "123"
        cellLabel.textColor = UIColor.segmentActive
        cellLabel.font = UIFont.bold17
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 4),
            cellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
