import Foundation
import UIKit

protocol RemoveFromCartViewController: UIViewController {
    func configureScreen(with nft: Nft)
    var onConfirm: (() -> Void)? { get set }
}

final class RemoveFromCartViewControllerImpl: UIViewController, RemoveFromCartViewController {
    // MARK: - Public Properties
    let presenter: RemoveFromCartPresenter
    
    var onConfirm: (() -> Void)?
    
    enum Constants {
        static let removeText = NSLocalizedString("RemoveFromCart_removeText", comment: "Confirmation message for removing item from cart")
        static let removeButtonText = NSLocalizedString("RemoveFromCart_removeButtonText", comment: "Text for the remove button")
        static let cancelButtonText = NSLocalizedString("RemoveFromCart_cancelButtonText", comment: "Text for the cancel button")
    }
    
    // MARK: - Private Properties
    private lazy var blureEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.dynamicBlack
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular17
        
        button.setTitleColor(UIColor.dynamicWhite, for: .normal)
        
        return button
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.dynamicBlack
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.regular17
        
        button.setTitleColor(UIColor.yaRedUniversal, for: .normal)
        
        return button
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.regular13
        label.textColor = UIColor.dynamicBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.red.cgColor
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Initializers
    init(presenter: RemoveFromCartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview()
        setupNftImageView()
        setupTextLabel()
        setupButtonsStackView()
        
        configureScreen()
    }
    
    
    // MARK: - Actions

    @objc private func didCancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func didRemoveButtonTapped(_ sender: UIButton) {
        onConfirm?()
        dismiss(animated: true)
    }
    
    // MARK: - Public Methods
    func configureScreen(with nft: Nft = Nft()) {
        textLabel.text = Constants.removeText
        cancelButton.setTitle(Constants.cancelButtonText, for: .normal)
        removeButton.setTitle(Constants.removeButtonText, for: .normal)
        guard let imageUrl = nft.images.first else {return}
        nftImageView.kf.setImage(with: imageUrl)
    }
    // MARK: - Private Methods
    
    private func addSubview() {
        view.addSubview(blureEffectView)
        view.addSubview(nftImageView)
        view.addSubview(textLabel)
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(removeButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }
    
    private func setupNftImageView() {
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ScreenSizeHelper.screenHeight * -0.1),
            
            nftImageView.widthAnchor.constraint(equalToConstant: 108 * ScreenSizeHelper.getViewMultiplier()),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor)
            
        ])
    }
    
    private func setupTextLabel() {
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12 * ScreenSizeHelper.getViewMultiplier()),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 97 * ScreenSizeHelper.getViewMultiplier()),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -97 * ScreenSizeHelper.getViewMultiplier())
        ])
    }
    
    private func setupButtonsStackView() {
        cancelButton.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)
        
        removeButton.addTarget(self, action: #selector(didRemoveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20 * ScreenSizeHelper.getViewMultiplier()),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 58 * ScreenSizeHelper.getViewMultiplier()),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -58 * ScreenSizeHelper.getViewMultiplier()),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44 * ScreenSizeHelper.getViewMultiplier())
        ])
    }
    
}
