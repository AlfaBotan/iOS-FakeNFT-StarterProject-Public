//
//  NFTCellForCollectionView.swift
//  FakeNFT
//
//  Created by Илья Волощик on 10.09.24.
//

import UIKit

final class NFTCellForCollectionView: UICollectionViewCell {
    
    static let reuseIdentifier = "NFTCollectionViewCell"
    
    private lazy var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.kf.indicatorType = .activity
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ethLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3medium
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraintView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nft: Nft) {
        let isLike = true
        let inCart = true
        nameLabel.text = nft.name
        let urlForImage = nft.images[0]
        nftImageView.kf.setImage(
            with: urlForImage,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        let imageForLike = isLike ? Images.Common.favoriteActive ?? UIImage() : Images.Common.favoriteInactive ?? UIImage()
        favoriteButton.setImage(imageForLike, for: .normal)
        let imageForCart = inCart ? Images.Common.deleteCartBtn?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal) :                                          Images.Common.addCart?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        cartButton.setImage(imageForCart, for: .normal)
        ethLabel.text = "\(nft.price) \(Strings.Common.eth)"
        updateRating(nft.rating)
    }
    
    private func updateRating(_ rating: Int) {
        for (i, view) in ratingStackView.arrangedSubviews.enumerated() {
            if let star = view as? UIImageView {
                if i < rating {
                    star.image = Images.Common.starActive
                } else {
                    star.image = Images.Common.startInactive
                }
            }
        }
    }
    
    private func constraintView() {
        for _ in 0..<5 {
            let star = UIImageView()
            star.image = Images.Common.startInactive ?? UIImage()
            star.contentMode = .scaleAspectFill
            star.translatesAutoresizingMaskIntoConstraints = false
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            star.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            ratingStackView.addArrangedSubview(star)
        }
        
        [nftImageView,
         ratingStackView,
         nameLabel,
         ethLabel,
         favoriteButton,
         cartButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            ethLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ethLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            cartButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
