protocol SignUpPresentable: BasePresentable {
    
    var confirmed: Bool { get set }
    var onSignUpComplete: CallbackClosure? { get set }
    var onTermsButtonTap: CallbackClosure? { get set }
    
    func conformTermsAgreement(_ agree: Bool)
}

final class SignUpController: UIViewController, SignUpPresentable {
  @IBOutlet weak var termsLabel: UILabel!
  @IBOutlet weak var signUpButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "SignUp"
    termsLabel.isHidden = true
    signUpButton.isEnabled = false
  }
  
  @IBAction func signUpClicked(_ sender: AnyObject) {
    if confirmed {
      onSignUpComplete?()
    }
  }
  
  @IBAction func termsButtonClicked(_ sender: AnyObject) {
    onTermsButtonTap?()
  }

    // MARK: - ---------------------- SignUpPresentable --------------------------
    //
    var onSignUpComplete: CallbackClosure?
    var onTermsButtonTap: CallbackClosure?
    
    var confirmed = false {
        didSet {
            termsLabel.isHidden = !confirmed
            signUpButton.isEnabled = confirmed
        }
    }
    func conformTermsAgreement(_ agree: Bool) {
        confirmed = agree
    }
}
