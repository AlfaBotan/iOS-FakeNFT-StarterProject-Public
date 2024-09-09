//
//  NFTCellForCollectionView.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit

final class NFTCellForCollectionView: UICollectionViewCell {
    
    static let Identifier = "TrackerCollectionViewCell"

    private lazy var topView: UIView = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIView = {
       let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previewImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
}
