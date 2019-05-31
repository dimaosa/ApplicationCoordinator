protocol TermsPresentable: BasePresentable {
    var confirmed: Bool { get set }
    var onConfirmChanged: Closure<Bool>? { get set }
}

class TermsController: UIViewController, TermsPresentable {
  
  @IBOutlet weak var termsSwitch: UISwitch! {
    didSet { termsSwitch.isOn = confirmed }
  }
  var confirmed = false
  var onConfirmChanged: ((Bool) -> ())?
  
  @IBAction func termsSwitchValueChanged(_ sender: UISwitch) {
    onConfirmChanged?(sender.isOn)
  }
}
