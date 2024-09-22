import UIKit

final class MyNftViewController: UIViewController {
    
    // Пример данных NFT
    private let nftData: [NFT] = [
        NFT(imageName: "2", name: "Lilo", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "3", name: "Spring", author: "John Doe", price: 1.78, rating: 3),
        NFT(imageName: "1", name: "April", author: "John Doe", price: 1.78, rating: 3)
    ]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupTableView()
        layoutTableView()
    }
    
    private func configureNavBar() {
        // Левая кнопка - стрелка "назад"
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        // "Мои NFT"
        let titleLabel = UILabel()
        titleLabel.text = "Мои NFT"
        titleLabel.font = .bodyBold
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
        
        // Правая кнопка сортировки
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func menuButtonTapped() {
        print("Меню нажато")
        
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        // Вариант сортировки по цене
        let sortByNameAction = UIAlertAction(title: "По цене", style: .default) { _ in
            weakSelf?.sortByPrice()
        }
        
        // Вариант сортировки по рейтингу
        let sortByPriceAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            weakSelf?.sortByRating()
        }
        
        // Вариант сортировки по названию
        let sortByRatingAction = UIAlertAction(title: "По названию", style: .default) { _ in
            weakSelf?.sortByName()
        }
        
        // Кнопка "Закрыть"
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByPriceAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Методы сортировки
    private func sortByName() {
        print("Сортировка по названию")
        // логика сортировки данных по названию
    }
    
    private func sortByPrice() {
        print("Сортировка по цене")
        // логика сортировки данных по цене
    }
    
    private func sortByRating() {
        print("Сортировка по рейтингу")
        //  логика сортировки данных по рейтингу
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyNftViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NftCell", for: indexPath) as! NftTableViewCell
        // Настройка ячейки - передача данных NFT в ячейку
        cell.configure(with: nftData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
