//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit
import Kingfisher

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(_ updatedProfile: UserProfile)
}

final class EditProfileViewController: UIViewController {
    weak var delegate: EditProfileDelegate?
    private var profile: UserProfile?
    
    //MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .bold22
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите имя"
        textField.font = .regular17
        textField.textColor = .segmentActive
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .bold22
        label.textColor = .segmentActive
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .regular17
        textView.textColor = .segmentActive
        textView.textAlignment = .left
        textView.textContainerInset = .init(top: 11, left: 16, bottom: 11, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = .bold22
        label.textColor = .segmentActive
        return label
    }()
    
    private let websiteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите Вебсайт"
        textField.font = .regular17
        textField.textColor = .segmentActive
        return textField
    }()
    
    //MARK: - Init
    init(profile: UserProfile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButton()
        loadProfileData()
    }
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateProfile()
    }
    
    //MARK: - Private Methods
    private func setupButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18 ,weight: .bold)
        let pencilImage = UIImage(systemName: "xmark", withConfiguration: largeConfig)
        
        closeButton.setImage(pencilImage, for: .normal)
        closeButton.tintColor = .segmentActive
        closeButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc private func saveButtonPressed() {
        updateProfile()
        dismiss(animated: true)
    }
    
    private func updateProfile() {
        guard let currentProfile = profile else { return }
        
        let updatedProfile = UserProfile(
            name: nameTextField.text ?? currentProfile.name,
            avatar: currentProfile.avatar,
            description: descriptionTextView.text ?? currentProfile.description,
            website: websiteTextField.text ?? currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
        
        delegate?.didUpdateProfile(updatedProfile)
    }

    private func loadProfileData() {
        nameTextField.text = profile?.name
        descriptionTextView.text = profile?.description
        websiteTextField.text = profile?.website
        
        if let profile = profile, let avatarURL = URL(string: profile.avatar) {
            avatarImage.kf.setImage(with: avatarURL)
        }
    }
    
    //MARK: - setupLayout()
    private func setupLayout() {
        let avatarStack = UIStackView(arrangedSubviews: [avatarImage])
        avatarStack.alignment = .center
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        nameStack.axis = .vertical
        nameStack.spacing = 8
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionStack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 8
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false
        
        let websiteStack = UIStackView(arrangedSubviews: [websiteLabel, websiteTextField])
        websiteStack.axis = .vertical
        websiteStack.spacing = 8
        websiteStack.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView(arrangedSubviews: [avatarStack, nameStack, descriptionStack, websiteStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        [nameTextField, descriptionTextView, websiteTextField].forEach {
            $0.backgroundColor = .segmentInactive
            $0.layer.cornerRadius = 12
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(closeButton)
        view.addSubview(mainStack)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            mainStack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

