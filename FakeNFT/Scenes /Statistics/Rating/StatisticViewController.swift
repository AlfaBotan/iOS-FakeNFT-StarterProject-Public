import UIKit

final class StatisticViewController: UIViewController, ViewSetupable {
    
    // MARK: - Public Properties
    var viewModel: StatisticViewModelProtocol
    
    // MARK: - Private Properties
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = Images.Common.sortBtn?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        button.setImage(image ?? UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scoreTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        table.rowHeight = 88
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Initializers
    init(viewModel: StatisticViewModelProtocol = StatisticViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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
        
        setupBindings()
        setupTable()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Public Methods
    func addSubviews() {
        view.addSubview(sortButton)
        view.addSubview(scoreTable)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: Constants.Layout.sortButtonWidth),
            sortButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.sortButtonTop),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.sortButtonTrailing),
            
            scoreTable.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: Constants.Layout.scoreTableTop),
            scoreTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.scoreTableLeading),
            scoreTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.scoreTableTrailing),
            scoreTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.Layout.scoreTableBottom)
        ])
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupBindings() {
        viewModel.reloadTableView = { [weak self] in
            self?.scoreTable.reloadData()
        }
        
        viewModel.showSortActionSheet = { [weak self] in
            self?.showSortAlert()
        }
        
        viewModel.loadMockData()
    }
    
    private func setupTable() {
        scoreTable.delegate = self
        scoreTable.dataSource = self
        scoreTable.register(StatisticsUserTableViewCell.self,
                            forCellReuseIdentifier: StatisticsUserTableViewCell.reuseIdentifier)
    }
    
    private func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.segmentActive
    }
    
    @objc private func sortButtonTapped() {
        viewModel.showSortOptions()
    }
    
    private func showSortAlert() {
        let alert = UIAlertController(title: Strings.Alerts.sortTitle, message: nil, preferredStyle: .actionSheet)
        
        let name = UIAlertAction(title: Strings.Alerts.sortByName, style: .default) { [weak self] _ in
            self?.viewModel.sortByName()
        }
        let rating = UIAlertAction(title: Strings.Alerts.sortByRating, style: .default) { [weak self] _ in
            self?.viewModel.sortByRating()
        }
        let close = UIAlertAction(title: Strings.Alerts.closeBtn, style: .cancel)
        
        alert.addAction(name)
        alert.addAction(rating)
        alert.addAction(close)
        
        present(alert, animated: true)   
    }
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsUserTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsUserTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user, and: indexPath.row+1)
        return cell
    }
}

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        let userCardViewModel = UserCardViewModel(user: user)
        let userCardViewController = UserCardViewController(viewModel: userCardViewModel)
        navigationController?.pushViewController(userCardViewController, animated: true)
    }
}

private enum Constants {
    enum Layout {
        static let sortButtonWidth: CGFloat = 42
        static let sortButtonTrailing: CGFloat = -9
        static let sortButtonTop: CGFloat = 0
        
        static let scoreTableTop: CGFloat = 20
        static let scoreTableLeading: CGFloat = 16
        static let scoreTableTrailing: CGFloat = -16
        static let scoreTableBottom: CGFloat = -13
    }
}

enum UserMock {
    static let mockStatisticsUserData: [UserStatistics] = [
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Alice Johnson", score: 108, bio: "Любит путешествовать и открывать новые места."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Bob Smith", score: 140, bio: "Увлекается фотографией и горными походами."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Charlie Brown", score: 132, bio: "Ведет блог о кулинарии."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Diana Prince", score: 125, bio: "Активный участник волонтерских программ."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Eve Adams", score: 120, bio: "Профессионально занимается дизайном интерьеров."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Frank Wright", score: 143, bio: "Любит спорт и участвует в марафонах."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Grace Hopper", score: 138, bio: "Изучает программирование и математику."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Harry Potter", score: 100, bio: "Любит приключения и игры с друзьями."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Isabelle McKenzie", score: 110, bio: "Пишет стихи и рассказы."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Jack Sparrow", score: 105, bio: "Мечтает об океанских приключениях."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Karen Black", score: 150, bio: "Интересуется модой и стилем."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Liam Neeson", score: 145, bio: "Любит смотреть кино и изучать актерское мастерство."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Mia Wallace", score: 130, bio: "Увлекается музыкой и играет на гитаре."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Nathan Drake", score: 118, bio: "Обожает приключения и активный отдых."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Olivia Wilde", score: 103, bio: "Интересуется искусством и занимается живописью."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Peter Parker", score: 135, bio: "Увлекается фотографией и научными экспериментами."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Quinn Harper", score: 113, bio: "Любит читать и путешествовать по миру."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Rachel Green", score: 128, bio: "Интересуется модой и дизайном."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Steve Rogers", score: 115, bio: "Проводит много времени на свежем воздухе и занимается спортом."),
        UserStatistics(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Tony Stark", score: 103, bio: "Гениальный инженер и изобретатель.")
    ]
}
