//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit
import ProgressHUD

final class CollectionViewController: UIViewController {
    
    private let viewModel: CollectionViewModelProtocol
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var topView: UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private lazy var nameLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .headline3
        return lable
    }()
    
    private lazy var firstAuthorLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .caption2
        return lable
    }()
    
    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.caption1
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.link, for: .normal)
        button.titleLabel?.font = font
        button.addTarget(self, action: #selector(goToAuthorURL), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .caption2
        lable.numberOfLines = .max
        return lable
    }()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(NFTCellForCollectionView.self, forCellWithReuseIdentifier: NFTCellForCollectionView.reuseIdentifier)
        collection.isScrollEnabled = false
        return collection
    }()
    
    init(viewModel: CollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configureNavBar()
        addConstraints()
        configureSubviews()
        loadData()
    }
    
    private func loadData() {
        ProgressHUD.show()
        ProgressHUD.animationType = .circleSpinFade
        viewModel.fetchNFTs {
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.collectionView.reloadData()
                self.updateCollectionViewHeight()
            }
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        contentView.addSubview(topImage)
        contentView.addSubview(topView)
        topView.addSubview(nameLable)
        topView.addSubview(firstAuthorLable)
        topView.addSubview(urlButton)
        contentView.addSubview(descriptionLable)
        contentView.addSubview(collectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            topImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 310),
            
            topView.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 16),
            topView.leadingAnchor.constraint(equalTo: topImage.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: topImage.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLable.topAnchor.constraint(equalTo: topView.topAnchor),
            nameLable.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            nameLable.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            nameLable.heightAnchor.constraint(equalToConstant: 28),
            
            firstAuthorLable.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5),
            firstAuthorLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            firstAuthorLable.widthAnchor.constraint(equalToConstant: 115),
            firstAuthorLable.heightAnchor.constraint(equalToConstant: 18),
            
            urlButton.leadingAnchor.constraint(equalTo: firstAuthorLable.trailingAnchor, constant: 4),
            urlButton.heightAnchor.constraint(equalToConstant: 28),
            urlButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            urlButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            
            descriptionLable.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLable.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLable.topAnchor.constraint(equalTo: topView.bottomAnchor),
            descriptionLable.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 800)
        collectionViewHeightConstraint?.isActive = true
    }
    
    func configureSubviews() {
        let pickedCollection = viewModel.getPickedCollection()
        let urlForImage = pickedCollection.cover
        topImage.kf.setImage(
            with: urlForImage,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        nameLable.text = pickedCollection.name
        urlButton.setTitle(pickedCollection.author, for: .normal)
        firstAuthorLable.text = Strings.Catalog.collectionAuthor
        descriptionLable.text = pickedCollection.description
    }
    
    func updateCollectionViewHeight() {
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let rows = CGFloat((numberOfItems / 3) + (numberOfItems % 3 == 0 ? 0 : 1))
        let itemHeight: CGFloat = 192
        let verticalSpacing: CGFloat = 8
        
        let totalHeight = rows * itemHeight + (rows - 1) * verticalSpacing
        collectionViewHeightConstraint?.constant = totalHeight
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func goToAuthorURL() {
        let nft = viewModel.collection(at: 0)
        guard let url = URL(string: nft.author) else { return }
        let webViewVC = AuthorWebViewController(url: url)
        navigationController?.pushViewController(webViewVC, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCellForCollectionView.reuseIdentifier,
                                                            for: indexPath) as? NFTCellForCollectionView
        else {
            print("Не прошёл каст к NFTCellForCollectionView")
            return UICollectionViewCell()
        }
        cell.delegate = self
        var isLike = false
        var inCart = false
        let nft = viewModel.collection(at: indexPath.row)
        let likes = viewModel.getLikes()
        let cart = viewModel.getCart()
        
        if let index = likes.firstIndex(of: nft.id) {
            isLike = true
        } else {
            isLike = false
        }
        
        if let index = cart.firstIndex(of: nft.id) {
            inCart = true
        } else {
            inCart = false
        }
        
        cell.prepareForReuse()
        cell.configure(nft: nft, isLike: isLike, nftID: nft.id, inCart: inCart)
        
        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftAndRightInset: CGFloat = 16
        return UIEdgeInsets(top: 8, left: leftAndRightInset, bottom: 8, right: leftAndRightInset)
    }
    
}

extension CollectionViewController: NFTCollectionViewCellDelegate {
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
