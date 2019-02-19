//
//  GridView.swift
//  TicTacToe
//
//  Created by Vincent Yu on 2/11/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class GridView: UIView {
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let lines = UIBezierPath()
        
        for i in 1...2 {
            // Vertical
            lines.move(to: CGPoint(x: width / 3 * CGFloat(i), y: 0))
            lines.addLine(to: CGPoint(x: width / 3 * CGFloat(i), y: height))
            
            // Horizontal
            lines.move(to: CGPoint(x: 0, y: height / 3 * CGFloat(i)))
            lines.addLine(to: CGPoint(x: width, y: height / 3 * CGFloat(i)))
            
            // Set properties
            lines.lineWidth = 5
            UIColor.purple.setStroke()
            lines.stroke()
        }
        
    }

}
