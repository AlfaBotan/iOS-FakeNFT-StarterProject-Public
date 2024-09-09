//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit

final class CollectionViewController: UIViewController {
    
     private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
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
        return lable
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func addSubviews() {
        view.addSubview(topImage)
        view.addSubview(topView)
        topView.addSubview(nameLable)
        topView.addSubview(firstAuthorLable)
        topView.addSubview(secondAuthorLable)
        view.addSubview(descriptionLable)
        view.addSubview(collectionView)
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
            topView.heightAnchor.constraint(equalToConstant: 136),
            
            nameLable.topAnchor.constraint(equalTo: topView.topAnchor),
            nameLable.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            nameLable.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            nameLable.heightAnchor.constraint(equalToConstant: 28),
            
            firstAuthorLable.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5),
            firstAuthorLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            firstAuthorLable.widthAnchor.constraint(equalToConstant: 115),
            firstAuthorLable.heightAnchor.constraint(equalToConstant: 18),
            
            secondAuthorLable.leadingAnchor.constraint(equalTo: firstAuthorLable.trailingAnchor, constant: 4),
            secondAuthorLable.heightAnchor.constraint(equalToConstant: 28),
            secondAuthorLable.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5),
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
}
