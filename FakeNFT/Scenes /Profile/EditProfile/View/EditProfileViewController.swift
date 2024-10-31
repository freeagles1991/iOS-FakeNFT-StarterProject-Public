//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Артур  Арсланов on 13.10.2024.
//

import UIKit
import Kingfisher

protocol EditProfileViewProtocol: AnyObject {
    func showProfile(_ profile: UserProfile)
    func didUpdateProfile(_ updatedProfile: UserProfile)
}

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(_ updatedProfile: UserProfile)
}

final class EditProfileViewController: UIViewController, EditProfileViewProtocol {
    private var presenter: EditProfilePresenterProtocol?
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
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сменить фото", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 35
        button.titleLabel?.font = .medium10
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(changeAvatarTapped), for: .touchUpInside)
        return button
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
        textField.setPadding(left: 16, right: 16)
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
        textField.setPadding(left: 16, right: 16)
        return textField
    }()
    
    //MARK: - Init
    init(profile: UserProfile, delegate: EditProfileDelegate?, userProfileService: UserProfileServiceProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = EditProfilePresenter(view: self, profile: profile, userProfileService: userProfileService)
        self.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadProfileData()
        setupLayout()
        setupButton()
    }
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateProfile()
    }
    
    //MARK: - Public Methods
    func showProfile(_ profile: UserProfile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        loadAvatar(from: profile.avatar)
    }
    
    func didUpdateProfile(_ updatedProfile: UserProfile) {
        delegate?.didUpdateProfile(updatedProfile)
    }
    
    //MARK: - Private Methods
    private func setupButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18 ,weight: .bold)
        let pencilImage = UIImage(systemName: "xmark", withConfiguration: largeConfig)
        
        closeButton.setImage(pencilImage, for: .normal)
        closeButton.tintColor = .segmentActive
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    private func updateProfile() {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let website = websiteTextField.text else { return }
        presenter?.saveProfileData(name: name, description: description, website: website)
    }
    
    private func loadAvatar(from urlString: String) {
        let placeholderImage = UIImage(named: "placeholderAvatar")
        guard let avatarURL = URL(string: urlString) else {
            avatarImage.image = placeholderImage
            return
        }
        
        avatarImage.kf.setImage(with: avatarURL, placeholder: placeholderImage)
    }
    
    //MARK: - Objc Methods
    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func changeAvatarTapped() {
        let alert = UIAlertController(title: "Изменить ссылку на изображение", message: "Введите новую ссылку на изображение", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "https://example.com/image.jpg"
            textField.keyboardType = .URL
        }
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self,
                  let urlString = alert.textFields?.first?.text,
                  !urlString.isEmpty else { return }
            
            self.avatarImage.kf.setImage(with: URL(string: urlString))
            
            self.presenter?.updateAvatarURL(urlString)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - setupLayout()
    private func setupLayout() {
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
        
        let mainStack = UIStackView(arrangedSubviews: [nameStack, descriptionStack, websiteStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        [nameTextField, descriptionTextView, websiteTextField].forEach {
            $0.backgroundColor = .segmentInactive
            $0.layer.cornerRadius = 12
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(avatarImage)
        view.addSubview(closeButton)
        view.addSubview(mainStack)
        
        avatarImage.addSubview(changeAvatarButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            changeAvatarButton.widthAnchor.constraint(equalTo: avatarImage.widthAnchor),
            changeAvatarButton.heightAnchor.constraint(equalTo: avatarImage.heightAnchor),
            changeAvatarButton.centerXAnchor.constraint(equalTo: avatarImage.centerXAnchor),
            changeAvatarButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            mainStack.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

