//
//  RatingView.swift
//  FakeNFT
//
//  Created by Дмитрий on 18.09.2024.
//

import UIKit

final class RatingView: UIStackView {
    
    private let maxRating = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .horizontal
        alignment = .leading
        spacing = 2
        translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<maxRating {
            let star = UIImageView()
            star.image = Images.Common.startInactive ?? UIImage()
            star.contentMode = .scaleAspectFill
            star.translatesAutoresizingMaskIntoConstraints = false
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            star.heightAnchor.constraint(equalToConstant: 12).isActive = true
            addArrangedSubview(star)
        }
    }
    
    func setRating(_ rating: Int) {
        for (i, view) in arrangedSubviews.enumerated() {
            if let star = view as? UIImageView {
                star.image = i < rating ? Images.Common.starActive : Images.Common.startInactive
            }
        }
    }
}
