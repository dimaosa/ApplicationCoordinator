protocol ItemCreatePresentable: BasePresentable {
    var onHideButtonTap: CallbackClosure? { get set }
    var onCompleteCreateItem: ((ItemList) -> ())? { get set }
}

final class ItemCreateController: UIViewController, ItemCreatePresentable {
  
  //controller handler
  var onHideButtonTap: CallbackClosure?
  var onCompleteCreateItem: ((ItemList) -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Create"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(ItemCreateController.hideButtonClicked(_:)))
  }
  
  @IBAction func hideButtonClicked(_ sender: UIBarButtonItem) {
    onHideButtonTap?()
  }
  
  @IBAction func createButtonClicked(_ sender: UIBarButtonItem) {
    onCompleteCreateItem?(ItemList(title: "", subtitle: ""))
  }
}
