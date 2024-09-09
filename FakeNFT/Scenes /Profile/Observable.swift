class Observable<T> {
    private var listener: ((T) -> Void)?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}
