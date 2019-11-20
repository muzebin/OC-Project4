//
//  ViewController.swift
//  Instagrid
//
//  Created by Jérôme Guèrin on 20/11/2019.
//  Copyright © 2019 Jérôme Guèrin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonLayoutOne: UIButton!
    @IBOutlet weak var buttonLayoutTwo: UIButton!
    @IBOutlet weak var buttonLayoutThree: UIButton!
    @IBOutlet weak var buttonTopLeft: UIButton!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomLeft: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!
    
    @IBAction func tapLayoutOne() {
        buttonTopLeft.isHidden = true
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    @IBAction func tapLayoutTwo() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = true
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(UIImage(named: "Selected"), for: .normal)
        buttonLayoutThree.setImage(nil, for: .normal)
    }
    
    @IBAction func tapLayoutThree() {
        buttonTopLeft.isHidden = false
        buttonTopRight.isHidden = false
        buttonBottomLeft.isHidden = false
        buttonBottomRight.isHidden = false
        buttonLayoutOne.setImage(nil, for: .normal)
        buttonLayoutTwo.setImage(nil, for: .normal)
        buttonLayoutThree.setImage(UIImage(named: "Selected"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapLayoutTwo()
    }
}

