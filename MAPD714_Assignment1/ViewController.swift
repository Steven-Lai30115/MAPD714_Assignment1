//
//  ViewController.swift
//  MAPD714_Assignment1
//  Calculator App
//  Created by  Pui Yan Cheung (301252393), Man Nok PUN (301269138), Chin Wai Lai(301257824).
//  Last modified 15:28 19 Sept 2022
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
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
    
    /**
        Buttons: C  Backspace
     */
    @IBAction func onDeleteButtonPressed(_ sender: UIButton) {
        var button = sender as UIButton
        var originalText = (button.titleLabel!.text ?? "") as String
        switch originalText {
            case "C":
                formulaLabel.text = ""
                resultLabel.text = ""
            default:
                var droplast = String((formulaLabel.text?.dropLast() ?? "")) as String
                formulaLabel.text = droplast
        }
    }
        
    /**
        Buttons: % .  +/-  +  -  *  /
     */
    @IBAction func onOperatorButtonPressed(_ sender: UIButton) {
        var button = sender as UIButton
        var originalText = (button.titleLabel!.text ?? "") as String
        print(originalText)
        switch originalText {
            case "%":
                formulaLabel.text?.append(originalText)
            case ".":
                formulaLabel.text?.append(originalText)
            case "+/-":
                // todo
                print ("+/- pressed")
            default : // + - * /
                formulaLabel.text?.append(originalText)
        }
        
    }
    /**
        Buttons: 0 1 2 3 4 5 6 7 8 9
     */
    @IBAction func onNumberButtonPressed(_ sender: UIButton) {
        var button = sender as UIButton
        var originalText = (button.titleLabel!.text ?? "") as String
        formulaLabel.text?.append(originalText)
    }
    
    /**
        Button: =
     */
    @IBAction func onEqualButtonPressed(_ sender: Any) {
        // todo: calculation
        resultLabel.text = "calculating..."
    }
}
