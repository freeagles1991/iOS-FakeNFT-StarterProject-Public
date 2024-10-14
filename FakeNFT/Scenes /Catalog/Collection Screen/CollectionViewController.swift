//  Created by Artem Morozov on 14.10.2024.


import UIKit

protocol CollectionViewC: AnyObject {
    func updateUI()
}

final class CollectionViewController: UIViewController {
    
    private let presenter: CollectionPresenter
    
    private lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var collectionImageView = UIImageView()
    private lazy var collectionNameLabel = UILabel()
    private lazy var collectionAuthorLabel = UILabel()
    private lazy var collectionDescriptionTextView = UITextView()
    
    // MARK: - Init
    
    init(presenter: CollectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - private functions
    
}

// MARK: - ConfigureUI

private extension CollectionViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureScrollView()
        configureCollectionImageView()
        configureCollectionNameLabel()
        configureCollectionAuthorLabel()
        configureCollectionDescriptionTextView()
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func configureCollectionImageView() {
        collectionImageView.image = UIImage(named: "catalogStubImage") ?? UIImage()
        collectionImageView.clipsToBounds = true
        collectionImageView.layer.cornerRadius = 12
        collectionImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionImageView.contentMode = .scaleAspectFill
        collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionImageView)
        
        NSLayoutConstraint.activate([
            collectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImageView.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    
    func configureCollectionNameLabel() {
        collectionNameLabel.text = presenter.selectedCollection.name
        collectionNameLabel.textColor = UIColor.segmentActive
        collectionNameLabel.font = UIFont.bold22
        collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionNameLabel)
        
        NSLayoutConstraint.activate([
            collectionNameLabel.topAnchor.constraint(equalTo: collectionImageView.bottomAnchor, constant: 16),
            collectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func configureCollectionAuthorLabel() {
        collectionAuthorLabel.text = "Автор коллекции: \(presenter.selectedCollection.author)"
        collectionAuthorLabel.textColor = UIColor.segmentActive
        collectionAuthorLabel.font = UIFont.regular13
        collectionAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionAuthorLabel)
        
        NSLayoutConstraint.activate([
            collectionAuthorLabel.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 8),
            collectionAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    func configureCollectionDescriptionTextView() {
        collectionDescriptionTextView.text = presenter.selectedCollection.description
        collectionDescriptionTextView.isScrollEnabled = false
        collectionDescriptionTextView.font = UIFont.regular13
        collectionDescriptionTextView.textColor = UIColor.segmentActive
        collectionDescriptionTextView.textContainer.lineFragmentPadding = 0
        collectionDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionDescriptionTextView)
        
        let size = CGSize(width: contentView.frame.width - 32, height: .infinity)
        let estimatedSize = collectionDescriptionTextView.sizeThatFits(size)
        
        NSLayoutConstraint.activate([
            collectionDescriptionTextView.topAnchor.constraint(equalTo: collectionAuthorLabel.bottomAnchor),
            collectionDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionDescriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionDescriptionTextView.heightAnchor.constraint(equalToConstant: estimatedSize.height)
        ])
    }
}
