import UIKit
import CoreData

class NumeratorTimeTableController: UITableViewController {
    
    @IBOutlet var tableItems: UITableView!
    
    @IBAction func cancelToNumeratorViewController(segue:UIStoryboardSegue) { }
    
    @IBAction func SaveNumeratorDetail(segue:UIStoryboardSegue) {
        updateWeek(false)
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateWeek(false) // загрузка данных для числителя
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count // количество секций в таблице
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.init(hue: 0.13, saturation: 0.50, brightness: 1, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 130, y: 14)
        label.textAlignment = NSTextAlignment.Left
        label.text = sections[section]
        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] // название секции в таблице
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Week[section].subjects[0].count // количество ячеек в секции
    }
    
    // заполнение каждой ячейки
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableItems.dequeueReusableCellWithIdentifier("numeratorTableCell")! as! SubjectTableCell
        let subject = Week[indexPath.section].subjects[0][indexPath.row] as Subject
        cell.timeAtLabel.text = subject.timeAt
        cell.timeToLabel.text = subject.timeTo
        cell.subjectLabel.text = subject.subjectName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // реализация удаления ячейки из таблицы
        if editingStyle == .Delete {
            
            let managedContext = CoreDataHelper.instance.context
            let fetchRequest = NSFetchRequest(entityName: "Subject")
            var error: NSError?
            
            do {
                
                let subj : Subject =  Week[indexPath.section].subjects[0][indexPath.row]
                
                let weekPredicate = NSPredicate(format:"week == %@", false);
                let dayPredicate = NSPredicate(format:"day == %@", subj.day!);
                let subjPredicate = NSPredicate(format:"subjectName == %@", subj.subjectName!);
                let timeAtPredicate = NSPredicate(format:"timeAt == %@", subj.timeAt!);
                let timeToPredicate = NSPredicate(format:"timeTo == %@", subj.timeTo!);
                let specPredicate = NSPredicate(format:"specification == %@", subj.specification!);
                
                let allPredicates = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [weekPredicate, dayPredicate, subjPredicate,timeAtPredicate, timeToPredicate, specPredicate])
                fetchRequest.predicate = allPredicates
                
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                // при условии существования двух и более абсолютно одинаковых Subject (с одним именем, описанием, днем, временем), будет удаляться только один из них, в силу того, что они одинаковые - не важно какой именно
                let deletingObj : NSManagedObject = (fetchedResults?.first)!
                
                CoreDataHelper.instance.context.deleteObject(deletingObj)
                CoreDataHelper.instance.save()
                
                updateWeek(false)
                tableView.reloadData()
            }
            catch{
                print(error)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Проверка на переход
        if segue.identifier == "NSubjectDetail"
        {
            // Получаем indexPath выбранной ячейки с помощью метода indexPathForCell:
            let indexPath = tableView.indexPathForCell((sender as! UITableViewCell)) // где sender - ячейка, на которую нажимает пользователь
            let subject = Week[indexPath!.section].subjects[0][indexPath!.row]
            let infoView: SubjectInfoView = segue.destinationViewController as! SubjectInfoView
            
            infoView.subject = subject // установка значения subject внутри SubjectInfoView
        }
    }
}