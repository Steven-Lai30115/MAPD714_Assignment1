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

    
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet var displayArea: UIView!
    @IBOutlet var buttonStackView: UIStackView!
    
    var lastButtonPressed: String = ""
    
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
        let button = sender as UIButton
        let originalText = (button.titleLabel!.text ?? "") as String
        switch originalText {
            case CalculatorButton.clear.name:
                formulaLabel.text = ""
                resultLabel.text = ""
            case CalculatorButton.backspace.name:
                let droplast = String((formulaLabel.text?.dropLast() ?? "")) as String
                formulaLabel.text = droplast
            default: return
        }
        lastButtonPressed = originalText
    }
        
    /**
        Buttons: % .  +/-  +  -  *  /
     */
    @IBAction func onOperatorButtonPressed(_ sender: UIButton) {
        let button = sender as UIButton
        let originalText = (button.titleLabel!.text ?? "") as String
        if( isInputInvalid(input: originalText) == false){
            switch originalText {
                case CalculatorButton.percentage.name:
                    if(lastButtonPressed == CalculatorButton.equal.name){ formulaLabel.text = "" }
                    formulaLabel.text?.append(originalText)
                case CalculatorButton.dot.name:
                    if(lastButtonPressed == CalculatorButton.equal.name){ formulaLabel.text = "" }
                    if(formulaLabel.text != nil && formulaLabel.text != "" && String((formulaLabel.text ?? "").last!).isNumber == true) { formulaLabel.text?.append(originalText)
                        } else {
                            formulaLabel.text?.append("0.")
                        }
                case CalculatorButton.plusMinus.name:
                    if(lastButtonPressed == CalculatorButton.equal.name){ formulaLabel.text = "" }
                    // todo
                    print ("+/- pressed")
                case CalculatorButton.add.name,CalculatorButton.subtract.name,CalculatorButton.multiply.name, CalculatorButton.divide.name:
                    if(lastButtonPressed == CalculatorButton.equal.name){
                        formulaLabel.text = resultLabel.text
                    }
                    formulaLabel.text?.append(originalText)
                default: return
            }
            lastButtonPressed = originalText
        }
        
    }
    /**
        Buttons: 0 1 2 3 4 5 6 7 8 9
     */
    @IBAction func onNumberButtonPressed(_ sender: UIButton) {
        let button = sender as UIButton
        let originalText = (button.titleLabel!.text ?? "") as String
        if( isInputInvalid(input: originalText) == false){
            if(lastButtonPressed == CalculatorButton.equal.name){ formulaLabel.text = "" }
            formulaLabel.text?.append(originalText)
            lastButtonPressed = originalText
        }
    }
    
    /**
        Button: =
     */
    @IBAction func onEqualButtonPressed(_ sender: UIButton) {
        let button = sender as UIButton
        let originalText = (button.titleLabel!.text ?? "") as String
        if( isInputInvalid(input: originalText) == false){
            // todo: calculation
            resultLabel.text = "123.456" // mock result
            lastButtonPressed = originalText
        }
        
    }
    
    func isInputInvalid(input: String) -> Bool {
        let _formulaText = ( lastButtonPressed == CalculatorButton.equal.name ) ? "" : formulaLabel.text
        var isInvalid = false
        if (_formulaText != "" && _formulaText != nil) {
            let lastDigit = String((_formulaText ?? "").last!)
            if( lastDigit.isNumber == true ){
                isInvalid =  [CalculatorButton.plusMinus.name].contains(input)
            } else if (lastDigit.isCalculateOperator == true){
                isInvalid = [ CalculatorButton.percentage.name, CalculatorButton.equal.name].contains(input) || input.isCalculateOperator
            } else if (lastDigit == CalculatorButton.dot.name){
                // todo: prevent multiple dots in a number
                isInvalid = [CalculatorButton.dot.name, CalculatorButton.plusMinus.name].contains(input)
            } else if (lastDigit == CalculatorButton.percentage.name){
                isInvalid = input.isNumberOperator || input.isNumber
            } else if (lastDigit == CalculatorButton.plusMinus.name){
                isInvalid = [CalculatorButton.percentage.name].contains(input) || input.isCalculateOperator
            }
        } else {
            if(resultLabel.text == ""){
                isInvalid = [ CalculatorButton.percentage.name, CalculatorButton.equal.name].contains(input) || input.isCalculateOperator
            } else if (resultLabel.text != ""){
                isInvalid = [CalculatorButton.percentage.name, CalculatorButton.equal.name].contains(input)
            }
        }
        if( isInvalid == true
            && !(input == CalculatorButton.equal.name && lastButtonPressed == CalculatorButton.equal.name)) {
            // spam clicking equal is considered as invalid but does not need to prompt error message
            self.view.makeToast("Invalid input")}
        return isInvalid
    }
}
