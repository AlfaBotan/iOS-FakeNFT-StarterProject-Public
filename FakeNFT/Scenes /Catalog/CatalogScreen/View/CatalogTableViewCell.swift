//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell {
    
    static let identifer = "CatalogTableViewCell"
    
    private lazy var topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.kf.indicatorType = .activity
        return image
    }()
    
    private lazy var nameAndCountLable: UILabel = {
        let nameAndCountLable = UILabel()
        nameAndCountLable.translatesAutoresizingMaskIntoConstraints = false
        nameAndCountLable.font = .bodyBold
        return nameAndCountLable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubViews() {
        contentView.addSubview(topImage)
        contentView.addSubview(nameAndCountLable)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 179)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            topImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 140),
            
            nameAndCountLable.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 4),
            nameAndCountLable.leadingAnchor.constraint(equalTo: topImage.leadingAnchor),
            nameAndCountLable.trailingAnchor.constraint(equalTo: topImage.trailingAnchor),
        ])
    }
    
    func configCell(name: String, count: Int, image: String) {
        let urlForImage = URL(string: image)
        topImage.kf.setImage(
            with: urlForImage,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        nameAndCountLable.text = "\(name) (\(count))"
    }
}
