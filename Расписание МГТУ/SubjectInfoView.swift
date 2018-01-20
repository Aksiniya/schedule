import UIKit

class SubjectInfoView: UITableViewController {
    
    var subject : Subject!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    // заполнение полей:
    override func viewWillAppear(animated: Bool) {
        if subject != nil {
            subjectTextField.text = subject.subjectName
            descTextView.text = subject.specification
            descTextView.font = UIFont.systemFontOfSize(17)
        }
    }
    
    override func viewDidLoad() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if subjectTextField.text >= "" {
            subject.subjectName = subjectTextField.text!
        }
        else {
            subject.subjectName = ""
        }
        
        if descTextView.text >= "" {
            subject.specification = descTextView.text!
        }
        else {
            subject.specification = ""
        }
        CoreDataHelper.instance.save()
    }
}