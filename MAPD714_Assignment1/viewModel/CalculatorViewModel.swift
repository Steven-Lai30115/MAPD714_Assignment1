//
//  CalculatorViewModel.swift
//  MAPD714_Assignment1
//
//  Created by Charlene Cheung on 27/9/2022.
//

import Foundation

class CalculatorViewModel: ObservableObject {
    
    // result
    var result : String = ""
    
    @Published var buttons: [[CalculatorButton]] = [
            [.clear, .plusMinus, .percentage, .divide],
            [.seven, .eight, .nine, .multiply],
            [.four, .five, .six, .subtract],
            [.one, .two, .three, .add],
            [ .zero, .dot, .equal]
        ]
    // number input
    var _numberInput: [String] = []
    var _operatorInput: [String] = []
    var _lastIsOperator : Bool?
    var _val1: String = ""
    var _val2: String = ""
    
    var operateSymbol: String = ""
    @Published var display: String = "0"
    
    var _isNumber: Bool = false
    var _isNumberOperator: Bool  = false
    var _isCalculateOperator: Bool  = false
    var _isNumberPack: Bool = false
    
    init() {
        
    }
    
    func add() -> Double {
        return (Double(self._val1)! + Double(self._val2)!)
    }
    
    func subtract() -> Double {
        return (Double(self._val1)! - Double(self._val2)!)
    }
    
    func multipy() -> Double {
        return (Double(self._val1)! * Double(self._val2)! )
    }
    
    func divide() -> Double {
        return (Double(self._val1)! / Double(self._val2)!)
    }
    
    func toPercentage(val: String) -> Double {
        return (Double(val)! / 100)
    }
    
    func toOpposeValue(val: String) -> Double {
        return Double(val)! / -1
    }
    
    func toFloatingPoint(val: String) -> String {
        var value:String = val
        if(!value.contains(CalculatorButton.dot.name)) {
            value = value + CalculatorButton.dot.name
        }
        return value
    }
    
    
    func updateVal1(val: String) {
        self._val1 = self._val1 + val
        self.display = self._val1
    }
    func updateVal2(val: String) {
        self._val2 = self._val2 + val
        self.display = self._val2
    }
    
    func _calculate() -> String {
        var answer: String = ""

        if(operateSymbol == CalculatorButton.add.name) {
            answer =  String(self.add())
        } else if(operateSymbol == CalculatorButton.subtract.name) {
            answer =   String(self.subtract())
        } else if(operateSymbol == CalculatorButton.multiply.name) {
            answer =   String(self.multipy())
        } else if(operateSymbol == CalculatorButton.divide.name) {
            answer =   String(self.divide())
        }
        return answer;
    }
    
    func clear() {
        _numberInput = []
        _operatorInput = []
        _lastIsOperator = nil
    }

    func backspace() {
        if(_operatorInput.isEmpty && _numberInput.isEmpty) {return}
        if (_lastIsOperator == true){
            _operatorInput.removeLast()
            _lastIsOperator = false
        } else {
            var lastNumber = _numberInput.popLast()
            
            if (lastNumber!.count) > 1 {
                let number = lastNumber!.dropLast()
                _numberInput.append(String(number))

            } else {
                _lastIsOperator = true
            }
        }
    }
    
    func getDisplay() ->String {
        var d: [String] = []
        let count = max(_numberInput.count, _operatorInput.count)
        for i in 0..<count {
            if i < _numberInput.count {d.append(_numberInput[i])}
            if i < _operatorInput.count {d.append(_operatorInput[i])}
        }
        return d.joined()
    }
    
    func handleNumberInput(input: String) {
        if (_lastIsOperator == nil) {
            _numberInput.append(input)

        } else if (_lastIsOperator == true) {
            _numberInput.append(input)
        } else {
            var val = _numberInput.popLast()!
            val = val + input
            _numberInput.append(val)
        }
        _lastIsOperator = false

    }
    
    func handleOperatorInput(input: String) {
        if(_numberInput.isEmpty) {return}
        _lastIsOperator = true
        if (input == CalculatorButton.dot.name) {
            if(_numberInput.last!.contains(".")) { return }
            var val = _numberInput.popLast()!
            val = val + "."

            return
        } else if(input == CalculatorButton.percentage.name) {
            let val = _numberInput.popLast()!
            _numberInput.append(String(self.toPercentage(val: val)))
            return
        } else if (input == CalculatorButton.plusMinus.name) {
            let val = _numberInput.popLast()!
            _numberInput.append(String(self.toOpposeValue(val: val)))

            return
        }
        _operatorInput.append(input)
    }
    
    func calculate(input: String) {
        
    }
    
    
}
