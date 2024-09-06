//
//  StatisticsUserTableViewCell.swift
//  FakeNFT
//
//  Created by Дмитрий on 06.09.2024.
//

import UIKit

final class StatisticsUserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "StatisticsUserTableViewCell"
    
    private let padding: CGFloat = 8
    
    private lazy var cellIndex: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor.textPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.segmentInactive
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: padding, right: 0))
    }
    
    func configure(with model: StatisticsUserCellModel, and index: Int) {
        cellIndex.text = "\(index)"
        avatarImageView.image = model.avatarImage.withTintColor(UIColor.segmentActive)
        nameLabel.text = model.name
        scoreLabel.text = "\(model.score)"
    }
    
    private func constraintViews() {
        
        contentView.addSubview(cellIndex)
        contentView.addSubview(bgView)
        
        [avatarImageView,
         nameLabel,
         scoreLabel].forEach {
            bgView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            cellIndex.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellIndex.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellIndex.widthAnchor.constraint(equalToConstant: 27),
            
            bgView.leadingAnchor.constraint(equalTo: cellIndex.trailingAnchor, constant: 8),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            avatarImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            scoreLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
