//
//  ProfileView.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 11.10.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

final class ProfileView: UIView {
    weak var delegate: ProfileViewDelegate?
    private var profile: UserProfile?
    private let titles = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    //MARK: - UI
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bold22
        label.textColor = UIColor.segmentActive
        return label
    }()
    
    private lazy var avatarPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var avatarNameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarPhoto, nameLabel])
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular13
        label.textColor = UIColor.segmentActive
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular15
        label.textColor = .blue
        return label
    }()
    
    private lazy var descriptionSiteStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, websiteLabel])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarNameStack, descriptionSiteStack])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tableView: UITableView = .init()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func update(with profile: UserProfile) {
        self.profile = profile
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
        loadAvatar(from: profile.avatar)
        tableView.reloadData()
    }
    
    //MARK: - Private Methods
    private func loadAvatar(from urlString: String) {
        let placeholderImage = UIImage(named: "placeholderAvatar")
        guard let avatarURL = URL(string: urlString) else {
            avatarPhoto.image = placeholderImage
            return
        }
        
        avatarPhoto.kf.setImage(with: avatarURL, placeholder: placeholderImage)
    }
    
    private func configureCell(_ cell: ProfileViewCell, at index: Int) {
        guard index < titles.count else { return }
        
        let title = titles[index]
        let count: Int? = {
            switch index {
            case 0: return profile?.nfts.count
            case 1: return profile?.likes.count
            default: return nil
            }
        }()
        
        cell.configure(with: title, count: count)
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            avatarPhoto.widthAnchor.constraint(equalToConstant: 70),
            avatarPhoto.heightAnchor.constraint(equalToConstant: 70),
            
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    //MARK: - setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: ProfileViewCell.identifier)
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
//MARK: - UITableViewDelegate
extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectItem(at: indexPath.row)
    }
}

//MARK: - UITableViewDataSource
extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as? ProfileViewCell else {
            return UITableViewCell()
        }
        
        configureCell(cell, at: indexPath.row)
        return cell
    }
    
}

