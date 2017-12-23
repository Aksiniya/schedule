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
        super.viewDidLoad()
    }
    
    //    func saveSubject() -> Bool {
    //
    //        if subjectTextField.text!.isEmpty {
    //            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Customer!", preferredStyle: .Alert)
    //            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    //            self.presentViewController(alert, animated: true, completion: nil)
    //            return false
    //        }
    //        else{
    //            subject.subjectName = subjectTextField.text!
    //            subject.specification = descTextView.text!
    //            CoreDataHelper.instance.save()
    //        }
    //        return true
    //    }
    
    override func viewWillDisappear(animated: Bool) {
        subject.subjectName = subjectTextField.text!
        subject.specification = descTextView.text!
        CoreDataHelper.instance.save()
    }
}