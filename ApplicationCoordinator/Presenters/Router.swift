protocol RouterProtocol: Presentable {
    
    func present(_ presentable: Presentable?)
    func present(_ presentable: Presentable?, animated: Bool)
    
    func push(_ presentable: Presentable?)
    func push(_ presentable: Presentable?, hideBottomBar: Bool)
    func push(_ presentable: Presentable?, animated: Bool)
    func push(_ presentable: Presentable?, animated: Bool, completion: CallbackClosure?)
    func push(_ presentable: Presentable?, animated: Bool, hideBottomBar: Bool, completion: CallbackClosure?)
    
    func popPresentable()
    func popPresentable(animated: Bool)
    
    func dismissPresentable()
    func dismissPresentable(animated: Bool, completion: CallbackClosure?)
    
    func setRootPresentable(_ presentable: Presentable?)
    func setRootPresentable(_ presentable: Presentable?, hideBar: Bool)
    
    func popToRootPresentable(animated: Bool)
}

final class Router: NSObject, RouterProtocol {
    
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : CallbackClosure]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]
    }
    
    var uiViewController: UIViewController? {
        return rootController
    }
    
    func present(_ presentable: Presentable?) {
        present(presentable, animated: true)
    }
    
    func present(_ presentable: Presentable?, animated: Bool) {
        guard let controller = presentable?.uiViewController else { return }
        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissPresentable() {
        dismissPresentable(animated: true, completion: nil)
    }
    
    func dismissPresentable(animated: Bool, completion: CallbackClosure?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ presentable: Presentable?)  {
        push(presentable, animated: true)
    }
    
    func push(_ presentable: Presentable?, hideBottomBar: Bool)  {
        push(presentable, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ presentable: Presentable?, animated: Bool)  {
        push(presentable, animated: animated, completion: nil)
    }
    
    func push(_ presentable: Presentable?, animated: Bool, completion: CallbackClosure?) {
        push(presentable, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ presentable: Presentable?, animated: Bool, hideBottomBar: Bool, completion: CallbackClosure?) {
        guard
            let controller = presentable?.uiViewController,
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popPresentable()  {
        popPresentable(animated: true)
    }
    
    func popPresentable(animated: Bool)  {
        if let controller = rootController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootPresentable(_ presentable: Presentable?) {
        setRootPresentable(presentable, hideBar: false)
    }
    
    func setRootPresentable(_ presentable: Presentable?, hideBar: Bool) {
        guard let controller = presentable?.uiViewController else { return }
        rootController?.setViewControllers([controller], animated: false)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootPresentable(animated: Bool) {
        if let controllers = rootController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
