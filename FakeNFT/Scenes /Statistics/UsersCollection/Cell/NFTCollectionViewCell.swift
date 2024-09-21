//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий on 08.09.2024.
//

import UIKit
import Kingfisher

protocol NFTCollectionViewCellDelegate: AnyObject {
    func tapLikeButton(with id: String)
}

final class NFTCollectionViewCell: UICollectionViewCell {

    // MARK: - Public Properties
    static let reuseIdentifier = "NFTCollectionViewCell"
    weak var delegate: NFTCollectionViewCellDelegate?

    // MARK: - Private Properties
    private var id: String = ""
    private var isLiked: Bool = false
    private var inCart: Bool = false
    
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
        let image = Images.Common.favoriteInactive ?? UIImage()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = Images.Common.addCart?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(tapCartButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingStackView = RatingView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(nft: NFTCellModel) {
        id = nft.id
        nameLabel.text = nft.name
        
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(
            with: nft.imageURL,
            placeholder: UIImage.from(color: .segmentActive),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
        
        ethLabel.text = "\(nft.cost) \(Strings.Common.eth)"
        ratingStackView.setRating(nft.rating)
        
        if nft.isLiked {
            changeLikeStatus()
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        [nftImageView,
         ratingStackView,
         nameLabel,
         ethLabel,
         favoriteButton,
         cartButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            ethLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ethLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 42),
            favoriteButton.heightAnchor.constraint(equalToConstant: 42),
            
            cartButton.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func changeLikeStatus() {
        isLiked = !isLiked
        let favoriteImage = isLiked ? Images.Common.favoriteActive : Images.Common.favoriteInactive
        favoriteButton.setImage(favoriteImage ?? UIImage(), for: .normal)
    }
    
    private func changeCartStatus() {
        inCart = !inCart
        let cartImage = inCart ? Images.Common.deleteCartBtn : Images.Common.addCartBtn
        cartImage?.withTintColor(UIColor.segmentActive, renderingMode: .alwaysOriginal)
        
        cartButton.setImage(cartImage ?? UIImage(), for: .normal)
    }
    
    @objc private func tapLikeButton() {
        changeLikeStatus()
        delegate?.tapLikeButton(with: id)
        // TODO: Добавить отправку лайка по сети, после реализации сервиса
    }
    
    @objc private func tapCartButton() {
        changeCartStatus()
        // TODO: Добавить отправку NFT в корзину, после реализации сервиса
    }
}
