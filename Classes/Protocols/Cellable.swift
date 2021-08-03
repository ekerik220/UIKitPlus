public protocol Cellable: AnyObject {}

public extension Cellable {
    static var reuseIdentifier: String { String(describing: self) }
}
