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
    
    
    func update(with profile: UserProfile) {
        self.profile = profile
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        websiteLabel.text = profile.website
        
        loadAvatar(from: profile.avatar)
        print(profile.nfts.count)
        tableView.reloadData()
    }
    
    private func loadAvatar(from urlString: String) {
        guard let avatarURL = URL(string: urlString) else {
            avatarPhoto.image = UIImage(named: "placeholderAvatar")
            return
        }
        
        avatarPhoto.kf.setImage(with: avatarURL) { [weak self] result in
            switch result {
            case .success(let value):
                print("Успешно загружено изображение: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                self?.avatarPhoto.image = UIImage(named: "placeholderAvatar")
            }
        }
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
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
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
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as? ProfileViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.configure(with: "Мои NFT", count: profile?.nfts.count)
        case 1:
            cell.configure(with: "Избранные NFT", count: profile?.likes.count)
        case 2:
            cell.configure(with: "О разработчике", count: nil)
        default:
            break
        }
        
        return cell
    }
    
}

