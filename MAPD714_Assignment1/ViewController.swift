//
//  ViewController.swift
//  MAPD714_Assignment1
//
//  Created by  Pui Yan Cheung (301252393), Man Nok PUN (301269138), Chin Wai Lai(301257824).
//  Last modified 15:28 19 Sept 2022
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet var displayArea: UIView!
    @IBOutlet var buttonStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        styleDisplayArea()
        styleAllButton()
    }

    // rounded effect on display area
    func styleDisplayArea() {
        displayArea.layer.cornerRadius = 20
        displayArea.layer.shadowRadius = 10
//        displayArea.layer.shadowOpacity = 1.0
//        displayArea.layer.shadowOffset = CGSize(width: -3, height: 3)
    }

    // turn all rect button to cicle button
    func styleAllButton() {
        for case let stackView as UIStackView in buttonStackView.subviews {
            for case let button as UIButton in stackView.subviews {
                button.layer.cornerRadius = button.frame.width / 2
                button.layer.masksToBounds = true
            }
        }
    }
}
