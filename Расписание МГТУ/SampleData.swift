import CoreData

// секции в таблицах числителя и знаменателя
let sections = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
// элементы для Picker'a в контроллере добавления предмета
var daysForPicker = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]

// структура, описывающая день для числителя и знаменателя
struct day_{
    var dayName : String
    var subjects = [ [Subject](), [Subject]() ]
}

// Заполнение всех дней недели
var NMondaySubjects : [Subject] = [ ]
var DMondaySubjects : [Subject] = [ ]
var Monday = day_(dayName: "Понедельник", subjects: [NMondaySubjects, DMondaySubjects] )

var NTuesdaySubjects : [Subject] = [ ]
var DTuesdaySubjects : [Subject] = [ ]
var Tuesday = day_(dayName: "Вторник", subjects: [NTuesdaySubjects, DTuesdaySubjects] )

var NWednesdaySubjects : [Subject] = [ ]
var DWednesdaySubjects : [Subject] = [ ]
var Wednesday = day_(dayName: "Среда", subjects: [NWednesdaySubjects, DWednesdaySubjects] )

var NThursdaySubjects : [Subject] = [ ]
var DThursdaySubjects : [Subject] = [ ]
var Thursday = day_(dayName: "Четверг", subjects: [NThursdaySubjects, DThursdaySubjects] )

var NFridaySubjects : [Subject] = [ ]
var DFridaySubjects : [Subject] = [ ]
var Friday = day_(dayName: "Пятница", subjects: [NFridaySubjects, DFridaySubjects] )

var NSaturdaySubjects : [Subject] = [ ]
var DSaturdaySubjects : [Subject] = [ ]
var Saturday = day_(dayName: "Суббота", subjects: [NSaturdaySubjects, DSaturdaySubjects] )

var NSundaySubjects : [Subject] = [ ]
var DSundaySubjects : [Subject] = [ ]
var Sunday = day_(dayName: "Воскресенье", subjects: [NSundaySubjects, DSundaySubjects] )

var Week = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]

// MARK: - загрузка данных в Week(или обновление массива Week)
func updateWeek(nORdWeek: Bool){
    
    let managedContext = CoreDataHelper.instance.context
    let fetchRequest = NSFetchRequest(entityName:"Subject")
    
    var error: NSError?
    
    do {
        fetchRequest.predicate = NSPredicate(format:"week == %@", nORdWeek);
        
        let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        if let subjects = fetchedResults {
            
            var subjectsInMonday = [Subject]()
            var subjectsInTuesday = [Subject]()
            var subjectsInWednesday = [Subject]()
            var subjectsInThursday = [Subject]()
            var subjectsInFriday = [Subject]()
            var subjectsInSaturday = [Subject]()
            var subjectsInSunday = [Subject]()
            
            for subject in subjects as! [Subject] {
                if subject.day == "Понедельник" {
                    subjectsInMonday.append(subject)
                }
                else if subject.day == "Вторник"{
                    subjectsInTuesday.append(subject)
                }
                else if subject.day == "Среда"{
                    subjectsInWednesday.append(subject)
                }
                else if subject.day == "Четверг"{
                    subjectsInThursday.append(subject)
                }
                else if subject.day == "Пятница"{
                    subjectsInFriday.append(subject)
                }
                else if subject.day == "Суббота"{
                    subjectsInSaturday.append(subject)
                }
                else if subject.day == "Воскресенье"{
                    subjectsInSunday.append(subject)
                }
            }
            
            let nORdWeekInInt = Int(nORdWeek)
            Monday.subjects[nORdWeekInInt] = subjectsInMonday
            Monday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Tuesday.subjects[nORdWeekInInt] = subjectsInTuesday
            Tuesday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Wednesday.subjects[nORdWeekInInt] = subjectsInWednesday
            Wednesday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Thursday.subjects[nORdWeekInInt] = subjectsInThursday
            Thursday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Friday.subjects[nORdWeekInInt] = subjectsInFriday
            Friday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Saturday.subjects[nORdWeekInInt] = subjectsInSaturday
            Saturday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Sunday.subjects[nORdWeekInInt] = subjectsInSunday
            Sunday.subjects[nORdWeekInInt].sortInPlace{ $0.timeAt < $1.timeAt }
            
            Week = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]
            
        } else {
            print("Could not fetch \(error), \(error!.userInfo)")
        }
        
    } catch {
        print(error)
    }
}