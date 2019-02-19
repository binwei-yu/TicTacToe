//
//  ViewController.swift
//  TicTacToe
//
//  Created by Vincent Yu on 2/11/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var InfoUIView: InfoView!
    @IBOutlet weak var GridUIView: GridView!
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var XImageView: UIImageView!
    @IBOutlet weak var OImageView: UIImageView!
    
    // State table
    var grid: Grid = Grid()
    
    // Initial position
    var XPosition: CGPoint?
    var OPosition: CGPoint?
    var result: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializtion
        XPosition = XImageView.frame.origin
        OPosition = OImageView.frame.origin
        
        // Disable OImageView
        OImageView.isUserInteractionEnabled = false
        OImageView.alpha = 0.5
    }

    // MARK: Actions
    @IBAction func PanXImageView(_ sender: UIPanGestureRecognizer) {
        guard let X = sender.view else { return }
        
        // During a Turn
        if sender.state == .changed {
            let translation = sender.translation(in: view)
            X.frame.origin.x += translation.x
            X.frame.origin.y += translation.y
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
        // End of a turn
        if sender.state == .ended {
            //var occupy_rate: CGFloat = 0.25 // Must be greater than 0.25
            var square: UIImageView?
            for subview in GridUIView.subviews {
                if let imageView = subview as? UIImageView {
                    // Unoccupied
                    if grid.isEmpty(row: (imageView.tag-1) / 3, col: (imageView.tag-1) % 3) {
                        // imageView's position is relative to the GridUIView,
                        // but XImage's is relative to the super view, hence
                        // we need to subtract GridUIView's offset
                        if imageView.frame.contains(
                            CGPoint(x: XImageView.center.x-GridUIView.frame.origin.x,
                                    y: XImageView.center.y-GridUIView.frame.origin.y)) {
                            square = imageView
                            break
                        }
                        /*
                        let intersection: CGRect = XImageView.frame.intersection(imageView.frame)
                        let rate = intersection.width * intersection.height / pow(imageView.frame.width, 2)
                        if rate >= occupy_rate {
                            square = imageView
                            occupy_rate = rate
                        }
                        */
                    }
                }
            }
            
            // Succeed
            if let imageView = square {
                // Filled grid
                imageView.image = UIImage(named: "X")
                self.result = grid.mark(row: (imageView.tag-1) / 3, col: (imageView.tag-1) % 3, mark: .X)
                
                // Judge
                if result != nil {
                    if result == .Tie {
                        InfoLabel.text = "Tie"
                        
                        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
                            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2 + 50)
                            //self.InfoUIView.center = self.view.center
                        }
                        animator.startAnimation()
                    }
                    else {
                        InfoLabel.text = "Congratulations, X wins"
                        
                        let path = UIBezierPath()
                        var start: CGPoint?
                        var end: CGPoint?
                        switch result! {
                        case .Horizontal:
                            start = GridUIView.viewWithTag((imageView.tag-1)/3*3+1)!.center
                            end = GridUIView.viewWithTag((imageView.tag-1)/3*3+3)!.center
                            break
                        case .Vertical:
                            start = GridUIView.viewWithTag((imageView.tag-1)%3+1)!.center
                            end = GridUIView.viewWithTag((imageView.tag-1)%3+7)!.center
                            break
                        case .Diagnol:
                            start = GridUIView.viewWithTag(1)!.center
                            end = GridUIView.viewWithTag(9)!.center
                            break
                        case .AntiDiagnol:
                            start = GridUIView.viewWithTag(3)!.center
                            end = GridUIView.viewWithTag(7)!.center
                            break
                        default:
                            fatalError("Unexpected Error: The result cannot be a tie")
                        }
                        print(start!.x)
                        print(start!.y)
                        start!.x += GridUIView.frame.origin.x
                        start!.y += GridUIView.frame.origin.y
                        end!.x += GridUIView.frame.origin.x
                        end!.y += GridUIView.frame.origin.y
                        path.move(to: start!)
                        path.addLine(to: end!)
                        path.close()
                        
                        let layer = CAShapeLayer()
                        layer.path = path.cgPath
                        layer.strokeEnd = 0
                        layer.lineWidth = 16
                        layer.strokeColor = UIColor.orange.cgColor
                        
                        view.layer.addSublayer(layer)
                        
                        let animation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.fromValue = 0.0
                        animation.toValue = 1.0
                        animation.duration = 2.5
                        
                        layer.add(animation, forKey: "line")
                        
                        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
                            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2 + 50)
                            //self.InfoUIView.center = self.view.center
                        }
                        animator.startAnimation(afterDelay: 2.5)
                    }
                }
                // Relocate piece
                XImageView.alpha = 0.5
                XImageView.isUserInteractionEnabled = false
                XImageView.frame.origin = XPosition!
                
                // Reset O image
                OImageView.alpha = 1.0
                OImageView.isUserInteractionEnabled = true
                
                // Draw attention
                OImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.OImageView.transform = .identity
                }, completion: nil)
            }
            // Failed
            else {
                let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                    self.XImageView.frame.origin = self.XPosition!
                }
                animator.startAnimation()
            }
        }
    }
    
    @IBAction func PanOImageView(_ sender: UIPanGestureRecognizer) {
        guard let O = sender.view else { return }
        
        if sender.state == .changed {
            let translation = sender.translation(in: view)
            O.frame.origin.x += translation.x
            O.frame.origin.y += translation.y
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
        
        // End of a turn
        if sender.state == .ended {
            // var occupy_rate: CGFloat = 0.25
            var square: UIImageView?
            for subview in GridUIView.subviews {
                if let imageView = subview as? UIImageView {
                    // Unoccupied
                    if grid.isEmpty(row: (imageView.tag-1) / 3, col: (imageView.tag-1) % 3) {
                        if imageView.frame.contains(
                            CGPoint(x: OImageView.center.x-GridUIView.frame.origin.x,
                                    y: OImageView.center.y-GridUIView.frame.origin.y)) {
                            square = imageView
                            break
                        }
                    }
                }
            }
            
            // Succeed
            if let imageView = square {
                // Filled grid
                imageView.image = UIImage(named: "O")
                self.result = grid.mark(row: (imageView.tag-1) / 3, col: (imageView.tag-1) % 3, mark: .O)
                
                // Judge
                if result != nil {
                    if result == .Tie {
                        InfoLabel.text = "Tie"
                        
                        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
                            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2 + 50)
                            //self.InfoUIView.center = self.view.center
                        }
                        animator.startAnimation()
                    }
                    else {
                        InfoLabel.text = "Congratulations, O wins"
                        
                        let path = UIBezierPath()
                        var start: CGPoint?
                        var end: CGPoint?
                        switch result! {
                        case .Horizontal:
                            start = GridUIView.viewWithTag((imageView.tag-1)/3*3+1)!.center
                            end = GridUIView.viewWithTag((imageView.tag-1)/3*3+3)!.center
                            break
                        case .Vertical:
                            start = GridUIView.viewWithTag((imageView.tag-1)%3+1)!.center
                            end = GridUIView.viewWithTag((imageView.tag-1)%3+7)!.center
                            break
                        case .Diagnol:
                            start = GridUIView.viewWithTag(1)!.center
                            end = GridUIView.viewWithTag(9)!.center
                            break
                        case .AntiDiagnol:
                            start = GridUIView.viewWithTag(3)!.center
                            end = GridUIView.viewWithTag(7)!.center
                            break
                        default:
                            fatalError("Unexpected Error: The result cannot be a tie")
                        }
                        start!.x += GridUIView.frame.origin.x
                        start!.y += GridUIView.frame.origin.y
                        end!.x += GridUIView.frame.origin.x
                        end!.y += GridUIView.frame.origin.y
                        path.move(to: start!)
                        path.addLine(to: end!)
                        path.close()
                        
                        let layer = CAShapeLayer()
                        layer.path = path.cgPath
                        layer.strokeEnd = 0
                        layer.lineWidth = 16
                        layer.strokeColor = UIColor.orange.cgColor
                        
                        view.layer.addSublayer(layer)
                        
                        let animation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.fromValue = 0.0
                        animation.toValue = 1.0
                        animation.duration = 2.5
                        
                        layer.add(animation, forKey: "line")
                        
                        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
                            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2 + 50)
                            //self.InfoUIView.center = self.view.center
                        }
                        animator.startAnimation(afterDelay: 2.5)
                    }
                }
                // Relocate piece
                OImageView.alpha = 0.5
                OImageView.isUserInteractionEnabled = false
                OImageView.frame.origin = OPosition!
                
                // Reset O image
                XImageView.alpha = 1.0
                XImageView.isUserInteractionEnabled = true
                
                // Draw attention
                XImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.XImageView.transform = .identity
                }, completion: nil)
            }
                // Failed
            else {
                let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                    self.OImageView.frame.origin = self.OPosition!
                }
                animator.startAnimation()
            }
        }
    }
    
    @IBAction func InfoButtom(_ sender: Any) {
        InfoLabel.text = "Get 3 in a row to win!"
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height / 2 + 50)
            //self.InfoUIView.center = self.view.center
        }
        animator.startAnimation()
    }
    
    @IBAction func OKButtom(_ sender: Any) {
        if self.result != nil {
            // Clear grid
            self.grid.clear()
            for subview in GridUIView.subviews {
                if let imageView = subview as? UIImageView {
                    let animator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
                        imageView.alpha = 0.0
                    }
                    animator.addCompletion() { _ in
                        imageView.image = nil
                        imageView.alpha = 1.0
                    }
                    animator.startAnimation()
                }
            }
            
            // Initialize
            XImageView.alpha = 1.0
            OImageView.alpha = 0.5
            XImageView.isUserInteractionEnabled = true
            OImageView.isUserInteractionEnabled = false
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height + 50)
        }
        animator.addCompletion() { _ in
            self.InfoUIView.transform = CGAffineTransform(translationX: 0, y: -100)
        }
        animator.startAnimation()
    }
    
    
}

