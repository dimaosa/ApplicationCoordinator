protocol ItemPresentableFactory {
  func makeItemsPresentable() -> ItemsListPresentable
  func makeItemDetailPresentable(item: ItemList) -> ItemDetailPresentable
}
