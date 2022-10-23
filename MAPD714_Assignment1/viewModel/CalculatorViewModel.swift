//
//  CalculatorViewModel.swift
//  MAPD714_Assignment2
//
//  Created by Pui Yan Cheung (301252393), Man Nok PUN (301269138), Chin Wai Lai(301257824).
//  Last modified 15:28 29 Sept 2022
//

import Foundation

class CalculatorViewModel: ObservableObject {
    
    private var userInput: String = ""
    private var userOutput: String = ""
    private var userInputList : [String] = []
    private var userInputIndexList : [CalculatorButtonType] = []
        
    func add(val1: String, val2: String) -> Double
    {
        let result = Double(val1)! + Double(val2)!
        return result.round8Digit
    }
    
    func subtract(val1: String, val2: String) -> Double
    {
        let result = Double(val1)! - Double(val2)!
        return result.round8Digit
    }
    
    func multiple(val1: String, val2: String) -> Double
    {
        let result = Double(val1)! * Double(val2)!
        return result.round8Digit
    }
    
    func divide(val1: String, val2: String) -> Double
    {
        let result = Double(val1)! / Double(val2)!
        return result.round8Digit
    }

    func toPercentage(val: String) -> Double
    {
        return Double(val)! / 100
    }
    
    func toOpposeValue(val: String) -> Double
    {
        return Double(val)! * -1
    }
    
    func toOpposeStringValue(val: String) -> String
    {
        if val.contains("-") {
            var t = val
            t.removeFirst()
            return "\(t)"
        } else {
            return "-\(val)"
        }
    }
    
    func addDot(val: String) -> String
    {
        return val + CalculatorButton.dot.name
    }
    
    func generateRandomNumber() -> String
    {
        return String(Float(arc4random()) / Float(UInt32.max))
    }
    
    func calculateSin(val: String) -> Double
    {
        let value = Double(val)
        return sin(value!)
    }
    
    func calculateCos(val: String) -> Double
    {
        let value = Double(val)
        return cos(value!)
    }
    
    func calculateTan(val: String) -> Double
    {
        let value = Double(val)
        return tan(value!)
    }
    
    func pi() -> Double {
        return Double(Float.pi)
    }
    
    func calculateSqrt(val: String) -> Double
    {
        let value = Double(val)
        return sqrt(value!)
    }
    
    func calculateSquare(val: String) -> Double
    {
        let value = Double(val)
        return value! * value!
    }
    
    func clear()
    {
        userInput = ""
        userInputList = []
        userInputIndexList = []
    }
    
    func backspace()
    {
        // TODO: BACKSPACE
    }
    
    func isEndCalcOperator() -> Bool?
    {
        if userInputIndexList.isEmpty {
            return nil
        }
        return userInputIndexList.last == CalculatorButtonType.calcOperator
    }
    
    private func isInteger(input: String) -> Bool
    {
        return !(
            input.contains(CalculatorButton.percentage.name)
            || input.contains(CalculatorButton.dot.name)
            || input.contains(CalculatorButton.plusMinus.name)
        )
    }
    
    private func isCalcOperator(input: String) -> Bool
    {
        return !(
            input == CalculatorButton.add.name
            || input == CalculatorButton.subtract.name
            || input == CalculatorButton.multiply.name
            || input == CalculatorButton.divide.name
        )
    }
    
    private func isNumericOperator(input: String) -> Bool
    {
        return !self.isInteger(input: input)
    }
    
    private func isRand(input: String) -> Bool
    {
        return input.contains(CalculatorButton.Rand.name)
    }
    
    private func isPi(input: String) -> Bool
    {
        return input.contains(CalculatorButton.Rand.name)
    }
    
    private func isNumericSymbol(input: String) -> Bool
    {
        return isPi(input: input) || isRand(input: input)
    }
    
    func handleNumberInput(input: String)
    {
        let isEndCalcOperator = self.isEndCalcOperator()
        if isEndCalcOperator != nil && isEndCalcOperator == true {
            self.migrate(input, buttonType: CalculatorButtonType.calcOperator)
        }
        
        if userInput.contains(CalculatorButton.Rand.name) ||
            userInput.contains(CalculatorButton.pi.name) {
            userInput = input
        } else {
            userInput = userInput + input
        }
    }
    
    func handleNumericOperatorInput(input: String)
    {
        if userInput.isEmpty {
            if input != CalculatorButton.dot.name ||
                userInput.contains(CalculatorButton.dot.name){
                return
            }
            
            if !userInput.contains(CalculatorButton.dot.name) {
                userInput = "0" + CalculatorButton.dot.name
            }
            
        } else {
            if input == CalculatorButton.dot.name {
                if userInput.contains(CalculatorButton.dot.name) { return }
                userInput = userInput + CalculatorButton.dot.name
                
            } else if input == CalculatorButton.percentage.name {
                if userInput.contains(CalculatorButton.percentage.name) { return }
                userInput = userInput + CalculatorButton.percentage.name
                
            } else {
                userInput = self.toOpposeStringValue(val: userInput)
                
            }
        }
    }
    
    private func migrate(_ input: String, buttonType: CalculatorButtonType)
    {
        print("migrate ", input, buttonType)
        userInputList.append(userInput)
        userInputIndexList.append(buttonType)
        userInput = input
    }
    
    func handleOperatorInput(input: String)
    {
        if userInput.isEmpty {
            return
        }
        
        let isEndCalcOperator = self.isEndCalcOperator()
        if isEndCalcOperator != nil && isEndCalcOperator == true{
            userInputList[-1] = input
            
        } else {
            self.migrate(input, buttonType: CalculatorButtonType.number)
            
        }
    }
    
    func handleInstantOperatorInput(input: String)
    {
        userInput = input
    }
    
    func calculate()
    {
        // TODO: CALCULATE
        userOutput = "10"
    }
    
    func getUserInput() -> String
    {
        return userInputList.isEmpty ?  userInput : userInputList.joined(separator: "") + userInput
    }
    
    func getUserOutput() -> String
    {
        return "0"
    }
}
