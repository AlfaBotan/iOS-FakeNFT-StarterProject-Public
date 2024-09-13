//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit

final class UserCollectionViewController: UIViewController {

    // MARK: - Private Properties
    private var viewModel: UserCollectionViewModelProtocol
    
    private lazy var userCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    // MARK: - Initializers
    init(viewModel: UserCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadNFTs()
        
        addSubviews()
        addConstraints()
        configureView()
        
        setupCollection()
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        view.addSubview(userCollectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            userCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.topSpacing),
            userCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.leading),
            userCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.Layout.trailing),
            userCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.Layout.bottomSpacing)
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
        userCollectionView.register(NFTCollectionViewCell.self, 
                                    forCellWithReuseIdentifier: NFTCollectionViewCell.reuseIdentifier)
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

private enum Constants {
    enum Layout {
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let topSpacing: CGFloat = 0
        static let bottomSpacing: CGFloat = 0
    }
}
