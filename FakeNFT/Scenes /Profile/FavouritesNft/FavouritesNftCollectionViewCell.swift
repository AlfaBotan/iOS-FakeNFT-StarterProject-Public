import UIKit

protocol FavouritesNftCollectionViewCellDelegate: AnyObject {
    func didTapHeartButton(id: String)
}

final class FavouritesNftCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: FavouritesNftCollectionViewCellDelegate?
    
    private let nftImageView = UIImageView()
    private let heartButton = UIButton()
    private let titleLabel = UILabel()
    private let starsView = UIStackView()
    private let priceLabel = UILabel()
    private var id: String = ""
    
    var heartButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nftImageView.layer.cornerRadius = 16
        nftImageView.clipsToBounds = true
        contentView.addSubview(nftImageView)
        
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.setImage(UIImage(named: "favoriteActive"), for: .normal)
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        titleLabel.font = .bodyBold
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        starsView.axis = .horizontal
        starsView.spacing = 2
        starsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starsView)
        
        priceLabel.font = .caption1
        priceLabel.textColor = .black
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            // Картинка
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Кнопка-сердце
            heartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 5.80),
            heartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -4.94),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Название
            titleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            // Звезды
            starsView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            starsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Цена
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func heartButtonTapped() {
        print("Heart button tapped")
        delegate?.didTapHeartButton(id: id)
    }
    
    func configure(with nft: Nft) {
        nftImageView.kf.setImage(
            with: nft.images[0],
            placeholder: UIImage(named: "ProfileMokIMG"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1))
            ]
        )
        self.id = nft.id
        titleLabel.text = nft.name.components(separatedBy: " ").first
        priceLabel.text = "\(nft.price) ETH"
        configureStars(rating: nft.rating)
    }
    
    private func configureStars(rating: Int) {
        for view in starsView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for _ in 0..<rating {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .yellow
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starsView.addArrangedSubview(starImageView)
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
        
        for _ in rating..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star"))
            starImageView.tintColor = .gray
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starsView.addArrangedSubview(starImageView)
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
    }
}
