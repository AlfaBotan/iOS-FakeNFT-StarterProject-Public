import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var profileContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.profileStackSpacing
        return stackView
    }()
    
    private lazy var avatarNameContainer: UIStackView = {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.spacing = Constants.avatarNameStackSpacing
        return horizontalStack
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray // Мок-картинка
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .headline3
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption2
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var linkTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .systemBlue
        textView.delegate = self
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var viewModel: ProfileViewModel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        guard viewModel != nil else {
            fatalError("viewModel не инициализирован!")
        }
        
        view.backgroundColor = .white
        configureNavBar()
        setupViews()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        
        view.addSubview(profileContainerView)
        view.addSubview(tableView)
        
        configureProfileContainer()
        
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topOffset),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalOffset),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalOffset)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: linkTextView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureProfileContainer() {
        avatarNameContainer.addArrangedSubview(avatarImageView)
        avatarNameContainer.addArrangedSubview(userNameLabel)
        
        profileContainerView.addArrangedSubview(avatarNameContainer)
        profileContainerView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(linkTextView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarWidthHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarWidthHeight)
        ])
        
        linkTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            linkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    // Привязка данных к UI
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        // Привязка имени
        viewModel.userName.bind { [weak self] name in
            DispatchQueue.main.async {
                self?.userNameLabel.text = name
            }
        }
        
        // Привязка описания
        viewModel.userDescription.bind { [weak self] description in
            DispatchQueue.main.async {
                self?.descriptionLabel.text = description
            }
        }
        
        // Привязка веб-сайта
        viewModel.userWebsite.bind { [weak self] website in
            DispatchQueue.main.async {
                self?.linkTextView.text = website
            }
        }
        
        // Привязка изображения профиля
        viewModel.userImage.bind { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
    
    private func configureNavBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(named: "EditButtonProfile"),
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        editButton.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func editButtonTapped() {
        // Обработка нажатия на кнопку
        print("Edit button tapped")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.menuItems[indexPath.row]
        
        cell.textLabel?.font = .bodyBold
        
        let accessoryImageView = UIImageView(image: UIImage(named: "chevron.forward"))
        accessoryImageView.contentMode = .scaleAspectFit
        
        
        cell.accessoryView = accessoryImageView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMenuItem(at: indexPath.row)
        
        if indexPath.row == 0 {
            let myNftVC = MyNftViewController()
            navigationController?.pushViewController(myNftVC, animated: true)
        }
        if indexPath.row == 1 {
            let favouritesNftVC = FavouritesNftViewController()
            navigationController?.pushViewController(favouritesNftVC, animated: true)
        }
        if indexPath.row == 2 {
            let webVC = WebViewController(urlString: "https://practicum.yandex.ru")
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        viewModel.didTapWebsite(url: URL)
        return false
    }
}

private enum Constants {
    static let profileStackSpacing: CGFloat = 16
    static let avatarCornerRadius: CGFloat = 35
    static let avatarWidthHeight: CGFloat = 70
    static let avatarNameStackSpacing: CGFloat = 16
    static let horizontalOffset: CGFloat = 16
    static let topOffset: CGFloat = 20
    static let tableViewTopInsets: CGFloat = 20
}
