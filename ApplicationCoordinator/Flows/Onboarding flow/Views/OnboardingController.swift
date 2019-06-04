protocol OnboardingPresentable: BasePresentable {
    var onFinish: CallbackClosure? { get set }
}

class OnboardingController: UIViewController, OnboardingPresentable {
    
    var onFinish: CallbackClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        onFinish?()
    }
}

