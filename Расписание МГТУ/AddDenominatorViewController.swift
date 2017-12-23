import UIKit

class AddDenominatorViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var TimeFromTextField: UITextField!
    @IBOutlet weak var TimeToTextField: UITextField!
    @IBOutlet weak var descr: UITextView!
    
    var subject = Subject()
    
    //    var daysForPicker = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let DayPicker = UIPickerView()
        DayPicker.delegate = self
        dayTextField.inputView = DayPicker
        
        subjectTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // при наборе текста в поле "предмет" при нажитии на return клавиатура будет скрываться
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        subjectTextField.resignFirstResponder()
        return true
    }
    
    func TimeToDatepickerValueChanged (sender: UIDatePicker) {
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateStyle = .NoStyle
        
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dateformatter.dateFormat = "HH:mm"
        
        TimeToTextField.text = dateformatter.stringFromDate(sender.date)
    }
    
    func TimeFromDatepickerValueChanged (sender: UIDatePicker) {
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateStyle = .NoStyle
        
        dateformatter.timeStyle = .ShortStyle
        
        dateformatter.dateFormat = "HH:mm"
        
        TimeFromTextField.text = dateformatter.stringFromDate(sender.date)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysForPicker.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysForPicker[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayTextField.text = daysForPicker[row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            subjectTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func TimeAtEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = .Time
        
        datePickerView.minuteInterval = 5
        
        // Установка формата даты: 24 часа
        datePickerView.locale = NSLocale(localeIdentifier: "en_GB")
        
        //        datePickerView.backgroundColor =
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddNumeratorViewController.TimeFromDatepickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func TimeToEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = .Time
        
        datePickerView.minuteInterval = 5
        
        // Установка формата даты: 24 часа
        datePickerView.locale = NSLocale(localeIdentifier: "en_GB")
        
        //        datePickerView.backgroundColor =
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddNumeratorViewController.TimeToDatepickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveAddSubject" {
            
            subject.subjectName = subjectTextField.text!
            subject.timeAt = TimeFromTextField.text!
            subject.timeTo = TimeToTextField.text!
            subject.specification = descr.text!
            subject.day = dayTextField.text!
            subject.week = true
            
            CoreDataHelper.instance.save()
        }
    }
}