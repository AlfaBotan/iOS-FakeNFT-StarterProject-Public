import UIKit
import ProgressHUD

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
        
        ProgressHUD.show()
        viewModel.loadData() {
            ProgressHUD.dismiss()
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Проверяем, является ли это последняя ячейка
        print(indexPath.row)
        if indexPath.row == viewModel.users.count - 1 {
            loadMoreDataIfNeeded()
        }
    }
    
    private func loadMoreDataIfNeeded() {
        // Здесь проверяем, не идет ли сейчас загрузка данных
        if !viewModel.isLoadingData {
            ProgressHUD.show()
            viewModel.loadData {
                ProgressHUD.dismiss()
            }
        }
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
