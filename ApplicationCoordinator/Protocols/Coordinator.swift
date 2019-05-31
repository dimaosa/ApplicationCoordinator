protocol ActionProtocol { }

/// Empty action is used when Coordinator doesn't have any actions
enum EmptyAction: ActionProtocol {}

/// Action with a single responsibility to dismiss presented view
enum DismissAction: ActionProtocol {
    case dismissFlow
}

protocol CoordinatorAction: class {
    associatedtype Action: ActionProtocol
    var listener: Closure<Action>? { get set }
}

protocol Coordinator: class {
    func start()
    func start(with option: DeepLinkOption?)
}

typealias ActionableCoordinator = CoordinatorAction & Coordinator
