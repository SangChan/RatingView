//
//  ViewController.swift
//  RatingView
//
//  Created by SangChan Lee on 1/24/17.
//  Copyright © 2017 SangChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingControl: RatingControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingControl.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : RatingViewDelegate {
    internal func ratingControl(ratingControl: RatingControl, changedToNewRate: Int) {
        print("[delegate]rate = \(changedToNewRate)")
    }
}

protocol RatingViewDelegate {
    func ratingControl(ratingControl:RatingControl, changedToNewRate:Int)
}

class RatingControl: UIView {
    var rate : Int = 0
    var padding : CGFloat = 5.0
    var numberOfStars : Int = 5
    var origin : CGPoint = CGPoint(x: 0, y: 0)
    var delegate : RatingViewDelegate?
    let emptyStarImage = UIImage(named: "emptyStar")
    let fullStarImage = UIImage(named: "fullStar")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initializer()
    }
    
    fileprivate func initializer() {
        self.backgroundColor = UIColor.clear
        //self.layer.borderColor = UIColor.red.cgColor
        //self.layer.borderWidth = 1.0
    }
    
    override func draw(_ rect: CGRect) {
        let middle_x = (self.bounds.size.width - (CGFloat(numberOfStars)*(fullStarImage?.size.width)!) - CGFloat(numberOfStars - 1) * padding)/2
        let middle_y = (self.bounds.size.height - (fullStarImage?.size.height)!)/2
        
        
        origin = CGPoint(x: middle_x, y: middle_y)
        
        var x = origin.x
        var i = 0
        while i < numberOfStars {
            if i > rate-1 {
                emptyStarImage?.draw(at: CGPoint(x: x, y: origin.y))
            } else {
                fullStarImage?.draw(at: CGPoint(x: x, y: origin.y))
            }
            
            x += (fullStarImage?.size.width)! + padding
            i += 1
        }
    }
    
    func handleTouchAtLocation(_ location:CGPoint) {
        var i = numberOfStars-1
        while i >= 0 {
            if location.x > origin.x + CGFloat(i) * ((fullStarImage?.size.width)! + padding) - padding / 2 {
                rate = i+1
                self.setNeedsDisplay()
                self.delegate?.ratingControl(ratingControl: self, changedToNewRate: rate)
                return
            }
            i -= 1
        }
        rate = 1
        self.setNeedsDisplay()
        self.delegate?.ratingControl(ratingControl: self, changedToNewRate: rate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchAtLocation((touches.first?.location(in: self))!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouchAtLocation((touches.first?.location(in: self))!)
    }
}
