//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    private let viewModel = CollectionViewModel()
    
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return image
    }()
    
    private lazy var topView: UIView = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var secondAuthorLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .caption1
        return lable
    }()
    
    private lazy var descriptionLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .caption2
        lable.numberOfLines = .max
        return lable
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(NFTCellForCollectionView.self, forCellWithReuseIdentifier: NFTCellForCollectionView.reuseIdentifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        loadData()
    }
    
    private func loadData() {
        viewModel.fetchCollections {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func addSubviews() {
        let closeButton = UIBarButtonItem(image: Images.Common.backBtn, style: .done, target: self, action: #selector(dismissViewController))
        closeButton.tintColor = .segmentActive
        navigationItem.leftBarButtonItem = closeButton
        
        view.addSubview(topImage)
        view.addSubview(topView)
        topView.addSubview(nameLable)
        topView.addSubview(firstAuthorLable)
        topView.addSubview(secondAuthorLable)
        view.addSubview(descriptionLable)
        view.addSubview(collectionView)
        
        topImage.image = UIImage(named: "peachMaxi")
        nameLable.text = "Peach"
        firstAuthorLable.text = Strings.Catalog.collectionAuthor
        secondAuthorLable.text = "John Doe"
        descriptionLable.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            topImage.topAnchor.constraint(equalTo: view.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            
            secondAuthorLable.leadingAnchor.constraint(equalTo: firstAuthorLable.trailingAnchor, constant: 4),
            secondAuthorLable.heightAnchor.constraint(equalToConstant: 28),
            secondAuthorLable.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            secondAuthorLable.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            
            descriptionLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLable.topAnchor.constraint(equalTo: topView.bottomAnchor),
            descriptionLable.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCollections()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCellForCollectionView.reuseIdentifier, for: indexPath) as? NFTCellForCollectionView
        else {
            print("Не прошёл каст")
            return UICollectionViewCell()
        }
        
        let nft = viewModel.collection(at: indexPath.row)
        cell.configure(nft: nft)
        
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
