protocol AuthPresentableFactory {
  func makeLoginPresentable() -> LoginPresentable
  func makeSignUpPresentable() -> SignUpPresentable
  func makeTermsPresentable() -> TermsPresentable
}
