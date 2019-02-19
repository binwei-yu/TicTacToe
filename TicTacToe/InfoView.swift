//
//  InfoView.swift
//  TicTacToe
//
//  Created by Vincent Yu on 2/12/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class InfoView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 20
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        
        // Shadow
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
