//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit

final class NFTCollectionViewCell: UICollectionView {
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()
    
    private lazy var ethLabel: UILabel = {
        let label = UILabel()
        label.font = 
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        
        return view
    }()
    
    
    private func constraintView() {
        
    }
}
