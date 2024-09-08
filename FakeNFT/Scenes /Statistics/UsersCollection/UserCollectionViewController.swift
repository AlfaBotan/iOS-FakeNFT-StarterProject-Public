//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit

final class UserCollectionViewController: UIViewController {
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        // layout.itemSize = CGSize(width: (view.frame.width / 3) - 9, height: 192)
        return layout
    }()
    private lazy var userCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupCollection()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        self.title = Strings.Statistics.collectionNft
    }
    
    private func setupCollection() {
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
    }
}

extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mockCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

extension UserCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 9, height: 192)
    }
}
