# ApplicationCoordinator
A lot of developers need to change navigation flow frequently, because it depends on business tasks. And they spend a huge amount of time for re-writing code. In this approach, I demonstrate our implementation of Coordinators, the creation of a protocol-oriented, testable architecture written on pure Swift without the downcast and, also to avoid the violation of the S.O.L.I.D. principles.

Based on the post about Application Coordinators [khanlou.com](http://khanlou.com/2015/10/coordinators-redux/) and Application Controller pattern description [martinfowler.com](http://martinfowler.com/eaaCatalog/applicationController.html).


### Coordinators Essential tutorial. Part I [medium.com](https://medium.com/blacklane-engineering/coordinators-essential-tutorial-part-i-376c836e9ba7)

### Coordinators Essential tutorial. Part II [medium.com](https://medium.com/@panovdev/coordinators-essential-tutorial-part-ii-b5ab3eb4a74)


Example provides very basic structure with 6 controllers and 5 coordinators with mock data and logic.
![](/str.jpg)

I used a protocol for coordinators in this example:
```swift
protocol Coordinator: class {
    func start()
    func start(with option: DeepLinkOption?)
}
```
All flow controllers(views or viewcontrollers) have a protocols (we need to configure blocks and handle callbacks in coordinators):
```swift
protocol ItemsListPresentable: BasePresentable {
    var authNeed: (() -> ())? { get set }
    var onItemSelect: (ItemList -> ())? { get set }
    var onCreateButtonTap: (() -> ())? { get set }
}
```
In this example I use factories for creating  coordinators and controllers (we can mock them in tests).
```swift
protocol CoordinatorFactory {
    func makeTabbarCoordinator(router: RouterProtocol) -> Coordinator
    func makeAuthCoordinatorBox(router: RouterProtocol) -> AuthCoordinator
    
    func makeOnboardingCoordinator(router: RouterProtocol) -> OnboardingCoordinator
}
```
The base coordinator stores dependencies of child coordinators (where Atomic is just a simple wrap)
```swift
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
```
Each coordinator has it own set of action which is defined in the same file as Coordinator. ActionPrtotocl is an empty protocol which shuold be confirmed by Coordinator Actions
```swift
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
```
Example of Coordinator
```
enum ItemCreateAction: ActionProtocol {
    case dismissFlow
    case item(ItemList)
}

final class ItemCreateCoordinator: BaseCoordinator<ItemCreateAction>{
    
  private let factory: ItemCreateModuleFactory
  private let router: RouterProtocol
  
  init(router: RouterProtocol, factory: ItemCreateModuleFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showCreate()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showCreate() {
    let createItemOutput = factory.makeItemAddOutput()
    createItemOutput.onCompleteCreateItem = { [weak self] item in
      self?.listener?(.item(item))
    }
    createItemOutput.onHideButtonTap = { [weak self] in
      self?.listener?(.dismissFlow)
    }
    router.setRootModule(createItemOutput)
  }
}
```
AppDelegate store lazy reference for the Application Coordinator
```swift
var rootController: UINavigationController {
    return self.window!.rootViewController as! UINavigationController
  }
  
  private lazy var applicationCoordinator: Coordinator = makeCoordinator()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
    let deepLink = DeepLinkOption.build(with: notification)
    applicationCoordinator.start(with: deepLink)
    return true
  }
  
  private func makeCoordinator() -> Coordinator {
      return ApplicationCoordinator(
        router: RouterImp(rootController: self.rootController),
        coordinatorFactory: CoordinatorFactoryImp()
      )
  }
```
