import CoreData

// секции в таблицах числителя и знаменателя
let sections = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
// элементы для Picker'a в контроллере добавления предмета
let daysForPicker = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
// элементы для Picker'a в контроллере загрузки расписания
let groupsForPicker = ["ИУ8-31", "ИУ8-32", "ИУ8-33", "ИУ8-34"]

//ссылки на группы в том же порядке, что и элементы для пикера групп
let groupsURL = ["https://students.bmstu.ru/schedule/62f2fc88-a264-11e5-916b-005056960017",
                 "https://students.bmstu.ru/schedule/62f4e1c4-a264-11e5-9e32-005056960017",
                 "https://students.bmstu.ru/schedule/62f5611c-a264-11e5-b4d3-005056960017",
                 "https://students.bmstu.ru/schedule/62f41f5a-a264-11e5-9d60-005056960017"]
// "Дивы"(/div[]/) для дней недели на сайте
let divDaysIndex = ["4", "6", "9", "11", "14", "16"]

// Время начала занятий
let timeAtArray = ["08:30", "10:15", "12:00", "13:50", "15:40", "17:25", "19:10"]
//Время окончания занятий
let timeToArray = ["10:05", "11:50",  "13:35", "15:25", "17:15", "19:00", "20:45"]

// Это для парсинга. Сначала в функции loadShedule (AppSettings.swift) все расписание загружается в NumeratorWeek и DenominatorWeek, а затем эти два массива "разбираются" в CoreData
var MondayNum : [String] = []
var MondayDen : [String] = []
var TuesdayNum : [String] = []
var TuesdayDen : [String] = []
var WednesdayNum : [String] = []
var WednesdayDen : [String] = []
var ThursdayNum : [String] = []
var ThursdayDen : [String] = []
var FridayNum : [String] = []
var FridayDen : [String] = []
var SaturdayNum : [String] = []
var SaturdayDen : [String] = []

var NumeratorWeek = [MondayNum, TuesdayNum, WednesdayNum, ThursdayNum, FridayNum, SaturdayNum]
var DenominatorWeek = [MondayDen, TuesdayDen, WednesdayDen, ThursdayDen, FridayDen, SaturdayDen]

// MARK: - очистка данных для новой загрузки
func clearNumDenWeek(){
    for i in 0...5 {
        NumeratorWeek[i].removeAll()
        DenominatorWeek[i].removeAll()
    }
}

// структура, описывающая день для числителя и знаменателя
struct day_{
    var dayName : String
    var subjects = [ [Subject](), [Subject]() ]
}

// Заполнение всех дней недели (это для таблиц Числитель и Знаменатель)
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