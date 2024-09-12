//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 07.09.2024.
//

import UIKit

final class UserCardViewController: UIViewController {

    // MARK: - Public Properties
    var viewModel: UserCardViewModelProtocol
    
    // MARK: - Private Properties
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
        button.setImage(Images.Common.forwardBtn, for: .normal)
        button.tintColor = .segmentActive
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(nil, action: #selector(tappedUserCollectionButton), for: .touchUpInside)
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
    
    // MARK: - Initializers
    init(viewModel: UserCardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.didTapCollectionButton = { [weak self] in
            let userCollectionVC = UserCollectionViewController()
            self?.navigationController?.pushViewController(userCollectionVC, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        addConstraints()
        configureView()
        
        setupNavBar()
        configure()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateButtonAppearance()
        }
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        [userPick,
         userName,
         userBio,
         siteButton,
         stackView,
         collectionButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            userPick.widthAnchor.constraint(equalToConstant: Constants.Layout.userPickSize),
            userPick.heightAnchor.constraint(equalTo: userPick.widthAnchor),
            userPick.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.topSpacing),
            userPick.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.leading),
            
            userName.centerYAnchor.constraint(equalTo: userPick.centerYAnchor),
            userName.leadingAnchor.constraint(equalTo: userPick.trailingAnchor, constant: Constants.Layout.leading),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.trailing),
            
            userBio.topAnchor.constraint(equalTo: userPick.bottomAnchor, constant: Constants.Layout.topSpacing),
            userBio.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.leading),
            userBio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.trailing),
            
            siteButton.topAnchor.constraint(equalTo: userBio.bottomAnchor, constant: Constants.Layout.userBioSpacing),
            siteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.leading),
            siteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.trailing),
            siteButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
            
            stackView.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: Constants.Layout.stackViewTopSpacing),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.leading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.trailing),
            stackView.heightAnchor.constraint(equalToConstant: Constants.Layout.stackViewHeight),
            
            collectionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            collectionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            collectionButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            collectionButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }

    @objc private func updateButtonAppearance() {
        // Обновляем цвет границы при смене темы
        if let button = view.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.layer.borderColor = UIColor.segmentActive.cgColor
        }
    }
    
    @objc private func tappedUserCollectionButton() {
        viewModel.tapCollectionButton()
    }
    
    private func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.segmentActive
    }
    
    private func configure() {
        userPick.image = viewModel.user.avatarImage
        userName.text = viewModel.user.name
        userBio.text = viewModel.user.bio
        collectionTitleLabel.text = "\(Strings.Statistics.collectionNft) (\(viewModel.user.score))"
    }
}

private enum Constants {
    enum Layout {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let topSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let stackViewHeight: CGFloat = 54
        static let collectionButtonHeight: CGFloat = stackViewHeight
        static let userPickSize: CGFloat = 70
        static let userBioSpacing: CGFloat = 28
        static let stackViewTopSpacing: CGFloat = 40
    }
}
