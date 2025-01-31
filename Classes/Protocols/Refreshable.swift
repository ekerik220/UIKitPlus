public protocol Refreshable: AnyObject {
    func refresh()
}

public extension Refreshable {
    // MARK: Reaction on @State

    @discardableResult
    func react<A>(to a: State<A>) -> Self {
        a.listen { [weak self] _, _ in self?.refresh() }
        return self
    }

    @discardableResult
    func react<A, B>(to a: State<A>, _ b: State<B>) -> Self {
        a.listen { [weak self] _, _ in self?.refresh() }
        b.listen { _, _ in self.refresh() }
        return self
    }

    @discardableResult
    func react<A, B, C>(to a: State<A>, _ b: State<B>, _ c: State<C>) -> Self {
        a.listen { [weak self] _, _ in self?.refresh() }
        b.listen { [weak self] _, _ in self?.refresh() }
        c.listen { [weak self] _, _ in self?.refresh() }
        return self
    }

    @discardableResult
    func react<A, B, C, D>(to a: State<A>, _ b: State<B>, _ c: State<C>, _ d: State<D>) -> Self {
        a.listen { [weak self] _, _ in self?.refresh() }
        b.listen { [weak self] _, _ in self?.refresh() }
        c.listen { [weak self] _, _ in self?.refresh() }
        d.listen { [weak self] _, _ in self?.refresh() }
        return self
    }

    @discardableResult
    func react<A, B, C, D, E>(to a: State<A>, _ b: State<B>, _ c: State<C>, _ d: State<D>, _ e: State<E>) -> Self {
        a.listen { [weak self] _, _ in self?.refresh() }
        b.listen { [weak self] _, _ in self?.refresh() }
        c.listen { [weak self] _, _ in self?.refresh() }
        d.listen { [weak self] _, _ in self?.refresh() }
        e.listen { [weak self] _, _ in self?.refresh() }
        return self
    }
}
