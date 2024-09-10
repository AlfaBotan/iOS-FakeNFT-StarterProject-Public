//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit

final class UserCollectionViewController: UIViewController, ViewSetupable {
    
    private var viewModel: UserCollectionViewModelProtocol
    
    private lazy var userCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    init(viewModel: UserCollectionViewModelProtocol = UserCollectionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        addConstraints()
        configureView()
        
        setupCollection()
        setupBindings()
        
        viewModel.loadNFTs()
    }
    
    func addSubviews() {
        view.addSubview(userCollectionView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            userCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataChanged = { [weak self] in
            self?.userCollectionView.reloadData()
        }
    }
    
    private func configureView() {
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
}

extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NFTCollectionViewCell.reuseIdentifier,
            for: indexPath) as? NFTCollectionViewCell,
              let nft = viewModel.item(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.configure(nft: nft)
        return cell
    }
}

extension UserCollectionViewController: UICollectionViewDelegate {
    // TODO: Реализовать в следующем спринте
}
