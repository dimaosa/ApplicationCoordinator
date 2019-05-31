protocol AuthModuleFactory {
  func makeLoginOutput() -> LoginPresentable
  func makeSignUpHandler() -> SignUpPresentable
  func makeTermsOutput() -> TermsPresentable
}
