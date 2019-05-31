protocol ItemModuleFactory {
  func makeItemsOutput() -> ItemsListPresentable
  func makeItemDetailOutput(item: ItemList) -> ItemDetailPresentable
}
