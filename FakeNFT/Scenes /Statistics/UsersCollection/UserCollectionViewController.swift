//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit
import ProgressHUD

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
        
        loadNFT()
        
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
    
    private func loadNFT() {
        ProgressHUD.show()
        viewModel.loadNFTs {
            ProgressHUD.dismiss() // Убираем индикатор после загрузки
        }
    }
    
    private func setupBindings() {
        viewModel.onDataChanged = { [weak self] in
            self?.userCollectionView.reloadData()
        }
        
        viewModel.showErrorAlert = { [weak self] alertText in
            self?.showAlert(with: alertText)
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
    
    private func showAlert(with text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        
        // TODO: Придумать как сделать кнопки универсальными
        let cancle = UIAlertAction(title: Strings.Cart.cancleBtn, style: .cancel) { _ in
            ProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        let reload = UIAlertAction(title: Strings.Cart.repeatBtn, style: .default) { [weak self] _ in
            self?.loadNFT()
        }
        
        alert.addAction(cancle)
        alert.addAction(reload)
        
        present(alert, animated: true)
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
        
        cell.delegate = self
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

extension UserCollectionViewController: NFTCollectionViewCellDelegate {
    func tapLikeButton(with id: String) {
        ProgressHUD.show()
        view.isUserInteractionEnabled = false
        viewModel.toggleLike(for: id) {
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func tapCartButton(with id: String) {
        ProgressHUD.show()
        view.isUserInteractionEnabled = false
        viewModel.toggleCart(for: id) {
            ProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
        }
    }
}
