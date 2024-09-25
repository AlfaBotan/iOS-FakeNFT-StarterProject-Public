import UIKit
import ProgressHUD

final class MyNftViewController: UIViewController {
    
    let viewModel: MyNftViewModel
    
    init(viewModel: MyNftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupTableView()
        layoutTableView()
        setupBindings()
        viewModel.applySavedSort()
        viewModel.loadNFT()
        //tableView.reloadData()
    }
    
    private func configureNavBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let titleLabel = UILabel()
        titleLabel.text = "Мои NFT"
        titleLabel.font = .bodyBold
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
        
        let menuButton = UIBarButtonItem(
            image: UIImage(named: "Vector"),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        menuButton.tintColor = .black
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NftTableViewCell.self, forCellReuseIdentifier: "NftCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
            viewModel.onDataChanged = { [weak self] in
                print("Data changed")
                self?.tableView.reloadData()
            }
        }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func menuButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            weakSelf?.viewModel.sort(by: .price)
            weakSelf?.tableView.reloadData()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            weakSelf?.viewModel.sort(by: .rating)
            weakSelf?.tableView.reloadData()
        }
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            weakSelf?.viewModel.sort(by: .name)
            weakSelf?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(sortByPriceAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(sortByNameAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyNftViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredNftData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NftCell", for: indexPath) as! NftTableViewCell
        let nft = viewModel.filteredNftData[indexPath.row]
        cell.delegate = self
        cell.configure(with: nft, isLiked: viewModel.favouriteList.contains(nft.id))
    
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MyNftViewController: MyNftTableViewCellDelegate {
    func didTapHeartButton(id: String) {
        ProgressHUD.show()
        viewModel.toggleLike(for: id) { 
            ProgressHUD.dismiss()
        }
    }
}
