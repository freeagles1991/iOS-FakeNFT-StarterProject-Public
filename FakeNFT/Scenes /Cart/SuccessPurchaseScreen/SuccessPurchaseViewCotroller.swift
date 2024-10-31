import Foundation
import UIKit

protocol SuccessPurchaseViewCotroller: UIViewController {
    var onConfirm: (() -> Void)? { get set }
    func updateNftImage(_ image: UIImage?)
    func loadNftImage(_ url: URL?)
}

final class SuccessPurchaseViewControllerImpl: UIViewController, SuccessPurchaseViewCotroller {
    
    // MARK: - Public Properties
    let presenter: SuccessPurchasePresenter
    var onConfirm: (() -> Void)?
    
    enum Constants {
        static let successString = NSLocalizedString("SuccessPurchase_SuccessMessage", comment: "Message displayed on successful purchase")
        static let doneButtonString = NSLocalizedString("SuccessPurchase_DoneButtonTitle", comment: "Title for the button to return to catalog")
    }

    // MARK: - Private Properties
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.dynamicBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.bold17
        
        button.setTitleColor(UIColor.dynamicWhite, for: .normal)
        
        return button
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold22
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = UIColor.dynamicBlack
        return label
    }()
    
    // MARK: - Initializers
    init(presenter: SuccessPurchasePresenter) {
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
        setupDoneButton()
        
        presenter.loadNftImage()
        
        view.backgroundColor = .systemBackground
    }
    // MARK: - Actions
    @objc private func didDoneButtonTapped() {
        onConfirm?()
        presenter.onDoneButtonTapped()
    }
    
    
    // MARK: - Public Methods
    func updateNftImage(_ image: UIImage?) {
        nftImageView.image = image
    }
    
    func loadNftImage(_ url: URL?) {
        nftImageView.kf.setImage(with: url)
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        view.addSubview(nftImageView)
        view.addSubview(textLabel)
        view.addSubview(doneButton)
    }
    
    private func setupNftImageView() {
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ScreenSizeHelper.screenHeight * -0.1),
            nftImageView.heightAnchor.constraint(equalToConstant: 278 * ScreenSizeHelper.getViewMultiplier()),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor)
        ])
    }
    
    private func setupTextLabel() {
        textLabel.text = Constants.successString
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36 * ScreenSizeHelper.getViewMultiplier()),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36 * ScreenSizeHelper.getViewMultiplier()),
            textLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 20 * ScreenSizeHelper.getViewMultiplier()),
        ])
    }
    
    private func setupDoneButton() {
        doneButton.addTarget(self, action: #selector(didDoneButtonTapped), for: .touchUpInside)
        doneButton.setTitle(Constants.doneButtonString, for: .normal)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16 * ScreenSizeHelper.getViewMultiplier()),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 * ScreenSizeHelper.getViewMultiplier()),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16 * ScreenSizeHelper.getViewMultiplier()),
            doneButton.heightAnchor.constraint(equalToConstant: 60 * ScreenSizeHelper.getViewMultiplier())
        ])
    }
}
