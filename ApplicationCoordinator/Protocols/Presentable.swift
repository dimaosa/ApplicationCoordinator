protocol Presentable {
    var uiViewController: UIViewController? { get }
}

extension UIViewController: Presentable {
    var uiViewController: UIViewController? {
        return self
   }
}
