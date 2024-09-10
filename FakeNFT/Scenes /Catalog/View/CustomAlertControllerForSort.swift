//
//  CustomAlertControllerForSort.swift
//  FakeNFT
//
//  Created by Илья Волощик on 9.09.24.
//

import UIKit

class CustomAlertControllerForSort: UIAlertController {
    private var customDimmingColor: UIColor?
    
    func setDimmingColor(_ color: UIColor) {
        customDimmingColor = color
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let color = customDimmingColor, let dimmingView = self.view.superview?.subviews.first {
            dimmingView.backgroundColor = color
        }
    }
}
