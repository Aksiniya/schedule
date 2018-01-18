import UIKit
import CoreData
import Kanna

class AppSettings: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
  
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupPicker: UIPickerView!
    
    @IBAction func loadButton(sender: AnyObject) {
        
        ClearFunc()
        
        var i = 0
        var URLAdress : String?
        for group in groupsForPicker{
            if groupLabel.text == group{
               URLAdress = groupsURL[i]
            }
            i += 1
        }
        i = 0
        
        if URLAdress != nil {
            loadShedule(URLAdress!)
        }
        else{
            loadSheduleErrorAlert()
        }
    }
    
    func loadShedule( URLAdress: String ){
       
        let URL = NSURL(string: URLAdress)

        let URLTask = NSURLSession.sharedSession().dataTaskWithURL(URL!){
            myData, response, error in
            
            guard error == nil else { self.loadSheduleErrorAlert(); return }
            
            let myHTMLString = String(data: myData!, encoding: NSUTF8StringEncoding)
            
            if let doc = Kanna.HTML(html: myHTMLString!, encoding: NSUTF8StringEncoding) {
                let bodyNode = doc.body
                
                clearNumDenWeek()
                
                var DayDivIntIndex = 0 // для итерации
                for DayDivIndex in divDaysIndex{
                    for DayTrIndex in 3...9 {
                        for WeekIndex in 2...3{
                            if let inputNodes = bodyNode?.xpath("/html/body/div[1]/div/div[\(DayDivIndex)]/table/tbody/tr[\(DayTrIndex)]/td[\(WeekIndex)]") {
                                
                                var value : String?
                                for node in inputNodes {
                                    value = node.text
                                }
                                if let v = value{
                                    if WeekIndex == 2{
                                        NumeratorWeek[DayDivIntIndex].append(v)
                                    }
                                    else if WeekIndex == 3{
                                        DenominatorWeek[DayDivIntIndex].append(v)
                                    }
                                }
                                else{
                                    DenominatorWeek[DayDivIntIndex].append(NumeratorWeek[DayDivIntIndex].last!)
                                }
                            }
                        }
                    }
                    DayDivIntIndex += 1
                }
                
                var subjFromArray : String
                for day in 0...5 {
                    for i in 0...6 {
                        
                        let NumSubject = Subject()
                        subjFromArray = NumeratorWeek[day][i]
                        
                        NumSubject.subjectName = subjFromArray
                        NumSubject.timeAt = timeAtArray[i]
                        NumSubject.timeTo = timeToArray[i]
                        NumSubject.specification = ""
                        NumSubject.day = sections[day]
                        NumSubject.week = false
                        
                        let DenSubject = Subject()
                        subjFromArray = DenominatorWeek[day][i]
                        
                        DenSubject.subjectName = subjFromArray
                        DenSubject.timeAt = timeAtArray[i]
                        DenSubject.timeTo = timeToArray[i]
                        DenSubject.specification = ""
                        DenSubject.day = sections[day]
                        DenSubject.week = true
                        
                        CoreDataHelper.instance.save()
                    }
                }
                self.loadSheduleSuccessAlert()
            }
        }
        URLTask.resume()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        groupPicker.delegate = self
        groupPicker.backgroundColor = UIColor.init(hue: 0.13, saturation: 0.50, brightness: 1, alpha: 1)

        groupLabel.text = groupsForPicker.first
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupsForPicker.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupsForPicker[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupLabel.text = groupsForPicker[row]
    }
    
    @IBAction func Clean(sender: AnyObject) {
    
        let alert = UIAlertController(title: "Удаление текущего расписания",
                                      message: "Действительно удалить текущее расписание?",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Да",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        self.ClearFunc()
        }
        saveAction.setValue(UIColor.redColor(), forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func ClearFunc(){
        // create the delete request for the specified entity
        let fetchRequest = NSFetchRequest(entityName: "Subject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataHelper.instance.context.executeRequest(deleteRequest)
//            CoreDataHelper.instance.save()
        } catch {
            print(error)
        }
    }
    
    func loadSheduleErrorAlert(){
        let alert = UIAlertController(title: "Ошибка загрузки расписания",
                                      message: "Не удалось загрузить расписание",
                                      preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ок",
                                     style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadSheduleSuccessAlert(){
        let goodLoad = UIAlertController(title: "Процесс завершен",
                                         message: "Расписание было успешно загружено",
                                         preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ок",
                                     style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        goodLoad.addAction(okAction)
        presentViewController(goodLoad, animated: true, completion: nil)
    }
}
