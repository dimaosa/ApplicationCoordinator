
final class AuthCoordinator: BaseCoordinator<DismissAction> {
    
  private let factory: AuthPresentableFactory
  private let router: RouterProtocol
  private weak var signUpView: SignUpPresentable?
  
  init(router: RouterProtocol, factory: AuthPresentableFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showLogin()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showLogin() {
    let loginPresentable = factory.makeLoginPresentable()
    loginPresentable.onCompleteAuth = { [weak self] in
      self?.listener?(.dismissFlow)
    }
    loginPresentable.onSignUpButtonTap = { [weak self] in
      self?.showSignUp()
    }
    router.setRootPresentable(loginPresentable)
  }
  
  private func showSignUp() {
    signUpView = factory.makeSignUpPresentable()
    signUpView?.onSignUpComplete = { [weak self] in
      self?.listener?(.dismissFlow)
    }
    signUpView?.onTermsButtonTap = { [weak self] in
      self?.showTerms()
    }
    router.push(signUpView)
  }
  
  private func showTerms() {
    let termsPresentable = factory.makeTermsPresentable()
    termsPresentable.confirmed = self.signUpView?.confirmed ?? false
    
    termsPresentable.onConfirmChanged = { [weak self] confirmed in
        self?.signUpView?.conformTermsAgreement(confirmed)
    }
    router.push(termsPresentable, animated: true)
  }
}
