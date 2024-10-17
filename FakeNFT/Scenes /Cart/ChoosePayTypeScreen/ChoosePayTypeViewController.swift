//
//  ChoosePayTypeViewController.swift
//  FakeNFT
//
//  Created by Дима on 16.10.2024.
//

import Foundation
import UIKit

protocol ChoosePayTypeViewController: UIViewController {
    
}

final class ChoosePayTypeViewControllerImpl: UIViewController, ChoosePayTypeViewController {
    let presenter: ChoosePayTypePresenter
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bold17
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 7
            layout.minimumLineSpacing = 7

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let cellIdentifier = "PayTypeItemCell"

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let interItemSpacing: CGFloat = 7
    private let verticalItemSpacing: CGFloat = 7
    private let itemAspectRatio: CGFloat = 46 / 168
    
    private let userAgreementPanelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaLightGrayDark : UIColor.yaLightGrayLight
        }

        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    let userAgreementTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false // Отключаем редактирование
        textView.isSelectable = true // Разрешаем выбор текста
        textView.isScrollEnabled = false // Отключаем прокрутку
        textView.backgroundColor = .clear // Убираем фон

        // Важно: Убираем dataDetectorTypes, чтобы избежать автоматической стилизации ссылок
        textView.dataDetectorTypes = [] // Отключаем автоматическое обнаружение ссылок

        return textView
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaBlackDark : UIColor.yaBlackLight
        }
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.bold17

        button.setTitleColor(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.yaWhiteDark : UIColor.yaWhiteLight
        }, for: .normal)

        return button
    }()
    
    enum Constants: String {
        case payScreenTitle = "Выбор способа оплаты"
        case userAgreementText = "Совершая покупку, вы соглашаетесь с условиями Пользовательского соглашения"
        case payButtonText = "Оплатить"
    }
    
    init(presenter: ChoosePayTypePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupNavigationBarTitle()
        setupCollectionView()
        setupButtonPanel()
        
        presenter.viewDidLoad()
    }
    

    
    //MARK: Верстка
    private func setupNavigationBarTitle() {
        self.title = Constants.payScreenTitle.rawValue
    }
    
    private func setupCollectionView() {
        collectionView.register(PayTypeCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupButtonPanel() {
        view.addSubview(userAgreementPanelView)
        
        NSLayoutConstraint.activate([
            userAgreementPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userAgreementPanelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userAgreementPanelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userAgreementPanelView.heightAnchor.constraint(equalToConstant: 184)
        ])
    
        userAgreementTextView.attributedText = makeUserAgreementLabelWithLink()
        userAgreementPanelView.addSubview(userAgreementTextView)
        
        NSLayoutConstraint.activate([
            userAgreementTextView.bottomAnchor.constraint(equalTo: userAgreementPanelView.bottomAnchor, constant: -4),
            userAgreementTextView.leadingAnchor.constraint(equalTo: userAgreementPanelView.leadingAnchor, constant: 16),
            userAgreementTextView.trailingAnchor.constraint(equalTo: userAgreementPanelView.trailingAnchor, constant: -16),
            userAgreementTextView.topAnchor.constraint(equalTo: userAgreementPanelView.topAnchor, constant: 16)
        ])
        
        userAgreementPanelView.addSubview(payButton)
        payButton.setTitle(Constants.payButtonText.rawValue, for: .normal)
        
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: userAgreementPanelView.bottomAnchor, constant: -48),
            payButton.leadingAnchor.constraint(equalTo: userAgreementPanelView.leadingAnchor, constant: 12),
            payButton.trailingAnchor.constraint(equalTo: userAgreementPanelView.trailingAnchor, constant: -12),
            payButton.topAnchor.constraint(greaterThanOrEqualTo: userAgreementPanelView.topAnchor, constant: 16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    //MARK: Private
    
    private func makeUserAgreementLabelWithLink() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: Constants.userAgreementText.rawValue)
        
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
        
        let font = UIFont.regular13
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        let linkRange = (Constants.userAgreementText.rawValue as NSString).range(of: "Пользовательского соглашения")
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.link, value: "https://www.example.com", range: linkRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.yaBlueUniversal, range: linkRange)

        return attributedString
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChoosePayTypeViewControllerImpl: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.payTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PayTypeCell
        cell.configure(with: presenter.payTypes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + interItemSpacing * (itemsPerRow - 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * itemAspectRatio
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
