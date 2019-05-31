protocol ItemDetailPresentable: BasePresentable { }

final class ItemDetailController: UIViewController, ItemDetailPresentable {
  
  //controller handler
  var itemList: ItemList?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = itemList?.title ?? "Detail"
  }
}
