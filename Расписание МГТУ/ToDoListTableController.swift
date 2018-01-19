import UIKit
import CoreData

class ToDoListTableController: UITableViewController{
    
    @IBOutlet weak var setDataButton: UIButton!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var tableItems: UITableView!
    @IBOutlet weak var BackgroundView: UIView!
    
    var items : [ ToDo ] = []
//    var firstDayOfEducationFromDataSource : NSDate? = nil
    var currentWeek : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // установка значка зубчатого колеса для настройки первого дня учебы
        setDataButton.setTitle(NSString(string: "\u{2699}\u{0000FE0E}") as String, forState: UIControlState.Normal)
        setDataButton.tintColor = UIColor.darkGrayColor()
        
        BackgroundView.backgroundColor = UIColor.init(hue: 0.13, saturation: 0.50, brightness: 1, alpha: 1)
        //убрать полосы вне таблицы
        tableItems.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadCurrentWeek()
        updateItemsArray()
        weekLabel.text = "\(currentWeek)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableItems.dequeueReusableCellWithIdentifier("ToDoCell")!
        cell.textLabel!.text = items[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let managedContext = CoreDataHelper.instance.context
            let fetchRequest = NSFetchRequest(entityName: "ToDo")
            
            var error: NSError?
            
            do {
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                
                let deletingObj : NSManagedObject = fetchedResults![indexPath.row]
                
                CoreDataHelper.instance.context.deleteObject(deletingObj)
                CoreDataHelper.instance.save()
                
                updateItemsArray()
                tableView.reloadData()
            }
            catch{
                print(error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.accessoryType == .None {
            cell!.accessoryType = .Checkmark
        } else {
            cell!.accessoryType = .None
        }
    }
    
    func saveToDo(textField : UITextField) -> Bool{
        
        if textField.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка!", message: "Поле ввода пустое - невозможно сохранить пустую ячейку.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        else{
            addNewToDoItemToCoreData(textField.text!)
            tableView.reloadData()
            return true
        }
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Добавление",
                                      message: "Создать новую ячейку",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Сохранить",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        let textField = alert.textFields![0]
                                        self.saveToDo(textField)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func addNewToDoItemToCoreData(name: String){
        let todo = ToDo()
        todo.name = name
        CoreDataHelper.instance.save()
        updateItemsArray()
    }
    
    func updateItemsArray(){
        
        let managedContext = CoreDataHelper.instance.context
        let fetchRequest = NSFetchRequest(entityName:"ToDo")
        
        var error: NSError?
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let todoItems = fetchedResults{
                
                var newItems : [ToDo] = []
                for i in todoItems as! [ToDo] {
                    newItems.append(i)
                }
                items = newItems
                
            } else {
                print("Could not fetch \(error), \(error!.userInfo)")
            }
        } catch {
            print(error)
        }
    }
    
    func updateWeekSettings(date : NSDate){
        let managedContext = CoreDataHelper.instance.context
        let fetchRequest = NSFetchRequest(entityName:"Settings")
        var error: NSError?
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let todoItems = fetchedResults{
                if let newSettings = todoItems.first as! Settings? {
                    newSettings.firstDayOfEducation = date
                    CoreDataHelper.instance.save()
                }
                else{
                    let newSettings = Settings()
                    newSettings.firstDayOfEducation = date
                    CoreDataHelper.instance.save()
                }
                
            } else {
                print("Could not fetch \(error), \(error!.userInfo)")
            }
        } catch {
            print(error)
        }
    }
    
    func loadCurrentWeek(){
        let currentDay = NSDate.init()
        let firstDay : NSDate
        
        let managedContext = CoreDataHelper.instance.context
        let fetchRequest = NSFetchRequest(entityName:"Settings")
        var error: NSError?
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let todoItems = fetchedResults{
                if let firstSet = todoItems.first as! Settings? {
                    firstDay = firstSet.firstDayOfEducation!
                    
                    let differensCurrentFirstData = currentDay.timeIntervalSinceDate(firstDay) / 60 / 60 / 24 / 7
                    currentWeek = Int(differensCurrentFirstData) + 1
                }
                else{
                    currentWeek = 0
                }
                
            } else {
                print("Could not fetch \(error), \(error!.userInfo)")
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func setFirstDayOfEducation(sender: AnyObject) {
        DatePickerDialog().show("Первый день учебы в семестре", doneButtonTitle: "Сохранить", cancelButtonTitle: "Отмена", datePickerMode: .Date){
            (date) -> Void in
            
            self.updateWeekSettings(date)
            self.loadCurrentWeek()
            self.weekLabel.text = "\(self.currentWeek)"
        }
    }
}