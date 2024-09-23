import UIKit

final class FavouritesNftViewController: UIViewController {
    
    private let viewModel = FavouritesNftViewModel()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.font = .bodyBold
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 168, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupCollectionView()
        setupEmptyLabel()
        checkEmptyState()
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
        titleLabel.text = "Избранные NFT"
        titleLabel.font = .bodyBold
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouritesNftCollectionViewCell.self, forCellWithReuseIdentifier: "NftCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkEmptyState() {
        if viewModel.getNftData().isEmpty {
            collectionView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavouritesNftViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNftData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NftCell", for: indexPath) as! FavouritesNftCollectionViewCell
        let nft = viewModel.getNftData()[indexPath.item]
        
        cell.configure(with: nft) { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.removeFromFavourites(at: indexPath.item)
            
            if self.viewModel.getNftData().isEmpty {
                self.collectionView.reloadData()
                self.checkEmptyState()
            } else {
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [indexPath])
                }) { _ in
                    self.collectionView.reloadData()
                    self.checkEmptyState()
                }
            }
        }
        return cell
    }
}
