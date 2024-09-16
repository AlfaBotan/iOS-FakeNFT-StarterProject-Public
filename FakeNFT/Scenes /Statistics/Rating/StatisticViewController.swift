import UIKit

final class StatisticViewController: UIViewController {
    
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
    
    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(sortButton)
        view.addSubview(scoreTable)
    }
    
    private func addConstraints() {
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
    static let mockStatisticsUserData: Users = [
        User(
            name: "Riley Glass",
            avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/664.jpg",
            description: "Test",
            website: "https://student1.students.practicum.org",
            nfts: [],
            rating: 13,
            id: "6a054eb1-8aa8-4e8b-b047-4e216dcee6df"
        ),
        User(
            name: "Rayan Gosling",
            avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/573.jpg",
            description: "easy brizi nfteasy",
            website: "https://www.facebook.com",
            nfts: [
                "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
                "f380f245-0264-4b42-8e7e-c4486e237504",
                "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3",
                "9810d484-c3fc-49e8-bc73-f5e602c36b40",
                "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
                "e33e18d5-4fc2-466d-b651-028f78d771b8",
                "db196ee3-07ef-44e7-8ff5-16548fc6f434",
                "ca34d35a-4507-47d9-9312-5ea7053994c0",
                "e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb",
                "d6a02bd1-1255-46cd-815b-656174c1d9c0",
                "de7c0518-6379-443b-a4be-81f5a7655f48",
                "7773e33c-ec15-4230-a102-92426a3a6d5a",
                "82570704-14ac-4679-9436-050f4a32a8a0"
            ],
            rating: 2,
            id: "61d3c8db-a147-4ae1-87cc-74329c18ff32"
        ),
        User(
            name: "Britney Wiley",
            avatar: "https://photo.bank/1.png",
            description: "param1Value",
            website: "https://yandex.ru",
            nfts: [
                "b3907b86-37c4-4e15-95bc-7f8147a9a660",
                "d6a02bd1-1255-46cd-815b-656174c1d9c0",
                "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
                "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
            ],
            rating: 66,
            id: "b400ce1f-7dac-4cf0-a866-bdb1911a04c4"
        )
    ]
}
