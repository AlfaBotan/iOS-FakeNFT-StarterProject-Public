//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 07.09.2024.
//

import UIKit

final class UserCardViewController: UIViewController {
    
    private let user: UserStatistics
    
    private lazy var userPick: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userBio: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .segmentActive
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var siteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Strings.Statistics.toAuthorSite, for: .normal)
        button.setTitleColor(UIColor.segmentActive, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.segmentActive.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Statistics.collectionNft
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal) // TODO: Вынести картинку в Images
        button.tintColor = .segmentActive
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [collectionTitleLabel, arrowButton])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(user: UserStatistics) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        constraintView()
        configure()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateButtonAppearance()
        }
    }
    
    @objc private func updateButtonAppearance() {
        // Обновляем цвет границы при смене темы
        if let button = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.layer.borderColor = UIColor.segmentActive.cgColor
        }
    }
    
    private func constraintView() {
        [userPick, userName, userBio, siteButton, stackView, collectionButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            userPick.widthAnchor.constraint(equalToConstant: 70),
            userPick.heightAnchor.constraint(equalTo: userPick.widthAnchor),
            userPick.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userPick.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            userName.centerYAnchor.constraint(equalTo: userPick.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPick.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userBio.topAnchor.constraint(equalTo: userPick.bottomAnchor, constant: 20),
            userBio.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userBio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            siteButton.topAnchor.constraint(equalTo: userBio.bottomAnchor, constant: 28),
            siteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 54),
            
            collectionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            collectionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            collectionButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            collectionButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    private func configure() {
        userPick.image = user.avatarImage
        userName.text = user.name
        userBio.text = user.bio
        collectionTitleLabel.text = "\(Strings.Statistics.collectionNft) (\(user.score))"
    }
}
