import UIKit

final class NftTableViewCell: UITableViewCell {
    
    private let nftImageView = UIImageView()
    private let heartButton = UIButton()
    private let titleLabel = UILabel()
    private let starsView = UIStackView()
    private let fromLabel = UILabel()
    private let authorLabel = UILabel()
    private let priceLabel = UILabel()
    private let priceTitleLabel = UILabel()
    private let authorStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        heartButton.setImage(UIImage(named: "favoriteInactive"), for: .normal)
        contentView.addSubview(heartButton)
        
        fromLabel.font = .caption1
        fromLabel.text = "от"
        fromLabel.textColor = .gray
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.font = .caption2
        authorLabel.textColor = .gray
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Настраиваем UIStackView для этих двух лейблов
        authorStackView.axis = .horizontal
        authorStackView.spacing = 1  // Отступ 1 пункт
        authorStackView.addArrangedSubview(fromLabel)
        authorStackView.addArrangedSubview(authorLabel)
        authorStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorStackView)
        
        titleLabel.font = .bodyBold
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        starsView.axis = .horizontal
        starsView.spacing = 2
        starsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starsView)
        
        priceTitleLabel.font = .caption2
        priceTitleLabel.textColor = .gray
        priceTitleLabel.text = "Цена"
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceTitleLabel)
        
        priceLabel.font = .bodyBold
        priceLabel.textColor = .black
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            heartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            heartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -8),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Стек лейблов "от John Doe"
            authorStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            authorStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -39),
            
            starsView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            starsView.bottomAnchor.constraint(equalTo: authorStackView.topAnchor, constant: -4),
            
            titleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: starsView.topAnchor, constant: -4),
            
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -81),
            priceTitleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -49)
        ])
    }
    
    // Метод для конфигурации ячейки
    func configure(with nft: NFT) {
        nftImageView.image = UIImage(named: nft.imageName)
        titleLabel.text = nft.name
        authorLabel.text = nft.author
        priceLabel.text = "\(nft.price) ETH"
        configureStars(rating: nft.rating)
    }
    
    // Метод для настройки звездочек
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
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starsView.addArrangedSubview(starImageView)
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
    }
}

struct NFT {
    let imageName: String
    let name: String
    let author: String
    let price: Double
    let rating: Int
}
