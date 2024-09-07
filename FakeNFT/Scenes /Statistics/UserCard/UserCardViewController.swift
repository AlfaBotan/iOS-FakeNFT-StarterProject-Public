//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Дмитрий on 07.09.2024.
//

import UIKit

final class UserCardViewController: UIViewController {
    
    private lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = UIColor.textPrimary
        return label
    }()
    
    private lazy var userBio: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor.textSecondary
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
}
