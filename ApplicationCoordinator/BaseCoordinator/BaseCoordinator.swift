
class BaseCoordinator<T: ActionProtocol>: ActionableCoordinator {
    typealias Action = T
    var listener: Closure<Action>?
  
    private var childCoordinators = Atomic<[Coordinator]>([])
    
    func start() {
        start(with: nil)
    }
    
    func start(with option: DeepLinkOption?) { }
    
    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
        guard !children.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.mutate({ $0.append(coordinator)} )
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            children.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        // Clear child-coordinators recursively
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.children.isEmpty {
            coordinator.children
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        for (index, element) in children.enumerated() where element === coordinator {
            childCoordinators.mutate {
                $0.remove(at: index)
            }
            break
        }
    }
    
    var children: [Coordinator] {
        return childCoordinators.value
    }
}
