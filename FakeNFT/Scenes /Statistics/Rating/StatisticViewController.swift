import UIKit

final class StatisticViewController: UIViewController {
    
    var viewModel: StatisticViewModelProtocol
    
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
    
    init(viewModel: StatisticViewModelProtocol = StatisticViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupBindings()
        setupTable()
        constraintView()
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
    
    private func constraintView() {
        view.addSubview(sortButton)
        view.addSubview(scoreTable)
        
        NSLayoutConstraint.activate([
            
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalTo: sortButton.widthAnchor),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            scoreTable.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            scoreTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scoreTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scoreTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13)
        ])
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

extension StatisticViewController: UITableViewDelegate {}

enum UserMock {
    static let mockStatisticsUserData: [StatisticsUserCellModel] = [
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Alice Johnson", score: 108),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Bob Smith", score: 140),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Charlie Brown", score: 132),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Diana Prince", score: 125),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Eve Adams", score: 120),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Frank Wright", score: 143),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Grace Hopper", score: 138),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Harry Potter", score: 100),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Isabelle McKenzie", score: 110),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Jack Sparrow", score: 105),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Karen Black", score: 150),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Liam Neeson", score: 145),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Mia Wallace", score: 130),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Nathan Drake", score: 118),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Olivia Wilde", score: 103),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Peter Parker", score: 135),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Quinn Harper", score: 113),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Rachel Green", score: 128),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Steve Rogers", score: 115),
        StatisticsUserCellModel(avatarImage: Images.TabBar.icon(for: .profile)!, name: "Tony Stark", score: 103)
    ]
}
