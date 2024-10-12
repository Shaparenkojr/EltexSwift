//
//  ViewController.swift
//  calc
//
//  Created by Тарас Шапаренко on 08.10.2024.
//

import UIKit

class ViewController: UIViewController {
    lazy var viewModel = ViewModel(closure: { [weak self] text in
        self?.label.text = text
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapZero(_ sender: UIButton) {
        viewModel.tupNumber(.zero)
        
    }
    
    
    @IBAction func tapOne(_ sender: UIButton) {
        viewModel.tupNumber(.one)
    }
    
    @IBAction func tapTwo(_ sender: UIButton){
        viewModel.tupNumber(.two)
    }
    
    @IBAction func tapThree(_ sender: UIButton){
        viewModel.tupNumber(.three)
    }
   
    @IBAction func tapFour(_ sender: UIButton){
        viewModel.tupNumber(.four)
    }
    
    @IBAction func tapFive(_ sender: UIButton){
        viewModel.tupNumber(.five)
    }
    
    @IBAction func tapSix(_ sender: UIButton){
        viewModel.tupNumber(.six)
    }
    @IBAction func tapSeven(_ sender: UIButton){
        viewModel.tupNumber(.seven)
    }
    
    @IBAction func tapEight(_ sender: UIButton){
        viewModel.tupNumber(.eight)
    }
    
    @IBAction func tapNine(_ sender: UIButton){
        viewModel.tupNumber(.nine)
    }
    @IBAction func AC(_ sender: UIButton){
        viewModel.tupNumber(.AC)
    }
    
    @IBAction func plus(_ sender: UIButton){
        viewModel.tupNumber(.plus)
    }

    @IBAction func eqal(_ sender: UIButton){
        viewModel.tupNumber(.equals)
    }

    
    @IBAction func minus(_ sender: UIButton){
        viewModel.tupNumber(.minus)
    }
    
    @IBAction func multiply(_ sender: UIButton){
        viewModel.tupNumber(.multiply)
    }

    @IBAction func divide(_ sender: UIButton){
        viewModel.tupNumber(.divide)
    }
    
    @IBAction func plusMinus(_ sender: UIButton){
        viewModel.tupNumber(.plusMinus)
    }
    
    @IBAction func percent(_ sender: UIButton){
        viewModel.tupNumber(.percent)

    }
    @IBAction func decimal(_ sender: UIButton){
        viewModel.tupNumber(.decimal)

    }
    
    @IBOutlet var label: UILabel!
}
class tapZeroButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 4.4
    }
}

class tapEqal: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}

class RadiusButtons: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}


enum Buttons{
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case AC
    case plus
    case equals
    case minus
    case multiply
    case divide
    case plusMinus
    case percent
    case decimal
    
}

class ViewModel {
    var currentValue: String = "0"  // Текущее введенное число
    var expression: String = ""     // Строка с полным выражением
    var lastOperation: Buttons?     // Последняя операция (например, +)
    var isTypingNumber = false      // Показывает, вводит ли пользователь новое число

    var closure: (String) -> ()
    
    init(closure: @escaping (String) -> ()) {
        self.closure = closure
    }
    
    func tupNumber(_ buttons: Buttons) {
        switch buttons {
        case .zero:
            if isTypingNumber || currentValue != "0" {
                addDigit("0")
            }
        case .one:
            addDigit("1")
        case .two:
            addDigit("2")
        case .three:
            addDigit("3")
        case .four:
            addDigit("4")
        case .five:
            addDigit("5")
        case .six:
            addDigit("6")
        case .seven:
            addDigit("7")
        case .eight:
            addDigit("8")
        case .nine:
            addDigit("9")
        case .AC:
            resetCalculator()
        case .plus, .minus, .multiply, .divide:
            appendOperation(buttons)
        case .equals:
            performCalculation()
        case .plusMinus:
            toggleSign()
        case .percent:
            applyPercent()
        case .decimal:
            addDecimal()
        }
        
        // Обновляем выражение или текущее число в зависимости от ситуации
        closure(expression + (isTypingNumber ? currentValue : ""))
    }
    
    private func addDigit(_ digit: String) {
        if !isTypingNumber {
            currentValue = digit
            isTypingNumber = true
        } else {
            currentValue += digit
        }
    }
    
    private func appendOperation(_ operation: Buttons) {
        if currentValue != "Error" {
            expression += currentValue + operationSymbol(operation)  // Добавляем число и операцию к выражению
            isTypingNumber = false  // Теперь пользователь будет вводить новое число
        }
    }
    
    private func performCalculation() {
        expression += currentValue
        
        // Используем NSExpression для вычисления выражения
        let exp = NSExpression(format: expression)
        if let result = exp.expressionValue(with: nil, context: nil) as? Double {
            currentValue = result == floor(result) ? "\(Int(result))" : "\(result)"
            
            // Обновляем вывод на экране результатом
            closure(currentValue)
            
            // Очищаем выражение, но оставляем результат для дальнейших операций
            expression = currentValue
        } else {
            currentValue = "Error"
            closure(currentValue)
        }
        
        isTypingNumber = false
    }
    
    private func toggleSign() {
        if currentValue != "0" {
            currentValue = currentValue.hasPrefix("-") ? String(currentValue.dropFirst()) : "-" + currentValue
        }
    }
    
    private func applyPercent() {
        let number = Double(currentValue) ?? 0
        currentValue = "\(number / 100)"
        closure(currentValue)
    }
    
    private func addDecimal() {
        if !currentValue.contains(".") {
            currentValue += "."
        }
        closure(currentValue)
    }
    
    private func resetCalculator() {
        currentValue = "0"
        expression = ""
        lastOperation = nil
        isTypingNumber = false
        closure(currentValue)
    }
    
    private func operationSymbol(_ operation: Buttons) -> String {
        switch operation {
        case .plus: return "+"
        case .minus: return "-"
        case .multiply: return "*"
        case .divide: return "/"
        default: return ""
        }
    }
}
