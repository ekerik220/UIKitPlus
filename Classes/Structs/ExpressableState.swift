public extension State {
    func map<Result>(_ expression: @escaping () -> Result) -> State<Result> {
        .init(self, expression)
    }

    func map<Result>(_ expression: @escaping (Value) -> Result) -> State<Result> {
        .init(self, expression)
    }
}

// MARK: Any States to Expressable

public protocol AnyState: AnyObject {
    func listen(_ listener: @escaping () -> Void)
}

public class AnyStates {
    private var _expression: (() -> Void)?

    @discardableResult
    init(_ states: [AnyState], expression: @escaping () -> Void) {
        _expression = expression
        for state in states {
            state.listen { [weak self] in
                self?._expression?()
            }
        }
    }
}

public extension Array where Element == AnyState {
    func map<Result>(_ expression: @escaping () -> Result) -> State<Result> {
        let state = State<Result>.init(wrappedValue: expression())
        AnyStates(self) { [weak state] in
            state?.wrappedValue = expression()
        }
        return state
    }
}
