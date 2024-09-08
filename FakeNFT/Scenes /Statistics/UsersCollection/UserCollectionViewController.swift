//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit

final class UserCollectionViewController: UIViewController {
    
    private lazy var userCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupCollection()
        constraintView()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        self.title = Strings.Statistics.collectionNft
    }
    
    private func setupCollection() {
        userCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.reuseIdentifier)
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let cellWidth: CGFloat = 108
        let cellHeight: CGFloat = 192
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 8
        
        return layout
    }
    
    private func constraintView() {
        view.addSubview(userCollectionView)
        
        NSLayoutConstraint.activate([
            userCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.reuseIdentifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = NFTCellModel(image: UIImage(named: "mockNFT") ?? UIImage(),
                               rating: 4,
                               name: "Archie",
                               cost: 1.78)
        cell.configure(nft: nft)
        
        return cell
    }
}

extension UserCollectionViewController: UICollectionViewDelegate {
    
}
