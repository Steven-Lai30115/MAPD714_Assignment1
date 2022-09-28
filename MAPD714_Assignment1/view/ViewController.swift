//
//  ViewController.swift
//  MAPD714_Assignment1
//  Calculator App
//  Created by  Pui Yan Cheung (301252393), Man Nok PUN (301269138), Chin Wai Lai(301257824).
//  Last modified 15:28 19 Sept 2022
//

import UIKit
import Toast

class ViewController: UIViewController {
    
    var viewModel : CalculatorViewModel = CalculatorViewModel()
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
         Buttons: Backspace
         */
        @IBAction func onDeleteButtonPressed(_ sender: UIButton) {
            let button = sender as UIButton
            viewModel.backspace()
            formulaLabel.text = viewModel.getDisplay()
        }
    
        /**
         Buttons: C (Clear)
         */
        @IBAction func onClearButtonPressed(_ sender: UIButton) {
            let button = sender as UIButton
            viewModel.clear()
            formulaLabel.text = viewModel.getDisplay()
        }
        
        /**
         Buttons: % .  +/-  +  -  *  /
         */
        @IBAction func onOperatorButtonPressed(_ sender: UIButton) {
            let button = sender as UIButton
            let input = (button.titleLabel!.text ?? "") as String
            viewModel.handleOperatorInput(input: input)
            formulaLabel.text = viewModel.getDisplay()
        }
        /**
         Buttons: 0 1 2 3 4 5 6 7 8 9
         */
        @IBAction func onNumberButtonPressed(_ sender: UIButton) {
            let button = sender as UIButton
            let input = (button.titleLabel!.text ?? "") as String
            viewModel.handleNumberInput(input: input)
            formulaLabel.text = viewModel.getDisplay()
        }
        
        /**
         Button: =
         */
        @IBAction func onEqualButtonPressed(_ sender: UIButton) {
            let button = sender as UIButton
            let input = (button.titleLabel!.text ?? "") as String
            viewModel.calculate(input: input)
        }
        
    }

