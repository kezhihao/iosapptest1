import SwiftUI

struct ContentView: View {
    @State private var displayNumber = "0"
    @State private var currentNumber = 0.0
    @State private var previousNumber = 0.0
    @State private var currentOperation: Operation? = nil
    @State private var shouldResetDisplay = false
    
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 12) {
                    // 作者署名和导航按钮
                    HStack {
                        Spacer()
                        Text("柯志豪制作")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        NavigationLink(destination: SecondView()) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Display
                    HStack {
                        Spacer()
                        Text(displayNumber)
                            .font(.system(size: 64))
                            .foregroundColor(.white)
                            .padding()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    
                    // Buttons
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { button in
                                CalculatorButtonView(button: button,
                                                  width: buttonWidth(for: button, in: geometry),
                                                  height: buttonHeight(in: geometry),
                                                  action: {
                                    self.tapped(button: button)
                                })
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black)
            }
        }
    }
    
    private func buttonWidth(for button: CalculatorButton, in geometry: GeometryProxy) -> CGFloat {
        switch button {
        case .zero:
            return (geometry.size.width - 5 * 12) / 2
        default:
            return (geometry.size.width - 5 * 12) / 4
        }
    }
    
    private func buttonHeight(in geometry: GeometryProxy) -> CGFloat {
        return (geometry.size.width - 5 * 12) / 4
    }
    
    func tapped(button: CalculatorButton) {
        switch button {
        case .number(let value):
            if shouldResetDisplay {
                displayNumber = "\(value)"
                shouldResetDisplay = false
            } else {
                if displayNumber == "0" {
                    displayNumber = "\(value)"
                } else {
                    displayNumber += "\(value)"
                }
            }
        case .clear:
            displayNumber = "0"
            currentNumber = 0
            previousNumber = 0
            currentOperation = nil
        case .decimal:
            if !displayNumber.contains(".") {
                displayNumber += "."
            }
        case .equals:
            calculateResult()
        case .add:
            setOperation(.add)
        case .subtract:
            setOperation(.subtract)
        case .multiply:
            setOperation(.multiply)
        case .divide:
            setOperation(.divide)
        case .plusMinus:
            if let value = Double(displayNumber) {
                displayNumber = "\(-value)"
            }
        case .percent:
            if let value = Double(displayNumber) {
                displayNumber = "\(value / 100)"
            }
        case .operation:
            break
        }
    }
    
    private func setOperation(_ operation: Operation) {
        if let value = Double(displayNumber) {
            if currentOperation != nil {
                calculateResult()
            } else {
                previousNumber = value
            }
        }
        currentOperation = operation
        shouldResetDisplay = true
    }
    
    private func calculateResult() {
        if let value = Double(displayNumber), let operation = currentOperation {
            currentNumber = value
            var result: Double = 0
            
            switch operation {
            case .add:
                result = previousNumber + currentNumber
            case .subtract:
                result = previousNumber - currentNumber
            case .multiply:
                result = previousNumber * currentNumber
            case .divide:
                result = previousNumber / currentNumber
            }
            
            displayNumber = formatResult(result)
            previousNumber = result
            currentOperation = nil
        }
    }
    
    private func formatResult(_ result: Double) -> String {
        if floor(result) == result {
            return String(Int(result))
        } else {
            return String(format: "%.8f", result).replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
        }
    }
}

enum CalculatorButton: Hashable {
    case number(Int)
    case operation(String)
    case clear, plusMinus, percent, decimal, equals
    case add, subtract, multiply, divide
    
    var title: String {
        switch self {
        case .number(let value): return "\(value)"
        case .operation(let symbol): return symbol
        case .clear: return "C"
        case .plusMinus: return "±"
        case .percent: return "%"
        case .decimal: return "."
        case .equals: return "="
        case .add: return "+"
        case .subtract: return "-"
        case .multiply: return "×"
        case .divide: return "÷"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .clear, .plusMinus, .percent:
            return .gray
        case .operation, .add, .subtract, .multiply, .divide, .equals:
            return .orange
        default:
            return .init(white: 0.3)
        }
    }
    
    static let zero = CalculatorButton.number(0)
    static let one = CalculatorButton.number(1)
    static let two = CalculatorButton.number(2)
    static let three = CalculatorButton.number(3)
    static let four = CalculatorButton.number(4)
    static let five = CalculatorButton.number(5)
    static let six = CalculatorButton.number(6)
    static let seven = CalculatorButton.number(7)
    static let eight = CalculatorButton.number(8)
    static let nine = CalculatorButton.number(9)
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(button.backgroundColor)
                    .frame(width: width, height: height)
                
                Text(button.title)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ContentView()
}