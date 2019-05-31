
protocol LoginPresentable: BasePresentable {
    var onCompleteAuth: CallbackClosure? { get set }
    var onSignUpButtonTap: CallbackClosure? { get set }
}

final class LoginController: UIViewController, LoginPresentable {
    
    //controller handler
    var onCompleteAuth: CallbackClosure?
    var onSignUpButtonTap: CallbackClosure?
    
    @IBAction func loginButtonClicked(_ sender: AnyObject) { onCompleteAuth?() }
    @IBAction func signUpClicked(_ sender: AnyObject) { onSignUpButtonTap?() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
    }
}
