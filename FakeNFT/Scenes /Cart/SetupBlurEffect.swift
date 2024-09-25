//
//  SetuoBlurEffect.swift
//  FakeNFT
//
//  Created by Alexander Salagubov on 17.09.2024.
//

import Foundation
import UIKit

extension UIView {
    func setupBlurEffect(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}
