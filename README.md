# <p align="center">Курсовой проект на тему <br/>«Разработка iOS приложения "Расписание"» 
<p align="center">
  <img src="https://github.com/Aksiniya/schedule/blob/master/images/BMSTU%20logo.png" width="200">
</p>

## Описание
Приложение "Расписание" ориентированно под учащихся по "мигающему расписанию" (на нечетных неделях (*числитель*) - одно расписание, на четных (*знаменаель*) - другое).
В приложении реализована функция добавления в список дел предстоящих событий.

## Внешний вид и использование
В основе лежит UITabBarController, с помощью которого можно переключаться между вкладками "Список дел", "Числитель", "Знаменатель".

### Список дел:

* Заполняйте таблицу дел своими ячейками и помечайте выполненные.
  * Чтобы добавить новую ячейку нажмите на `+` в верхнем правом углу экрана. После нажатия появится поле для ввода текста.
  * По нажатию на ячейку справа появляется CheckMark (галочка). Чтобы убрать CheckMark нажмите на ячейку повторно.
  * Чтобы удалить ячеку, проведите по ней влево. Справа появится кнопка для удаления.

![список дел image](https://github.com/Aksiniya/schedule/blob/master/images/%D1%81%D0%BF%D0%B8%D1%81%D0%BE%D0%BA%20%D0%B4%D0%B5%D0%BB.png)

![добавление дела](https://github.com/Aksiniya/schedule/blob/master/images/%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B4%D0%B5%D0%BB%D0%B0.png)

### Числитель и знаменатель:

* Заполняйте расписание созданными Вами предметами.
  * Чтобы создать новый предмет нажмите на `+` в верхнем правом углу экрана. После нажатия появится новый экран, где необходимо ввести параметры предмета - его название, время начала, время окончания и описание.
  * По нажатию на ячейку совершается преход на новый экран, где приводится описание предмета.
  * Чтобы удалить ячейку с предметом - проведите по ней влево. Справа появится кнопка для удаления.
  
![Числитель](https://github.com/Aksiniya/schedule/blob/master/images/%D1%87%D0%B8%D1%81%D0%BB%D0%B8%D1%82%D0%B5%D0%BB%D1%8C.png)    ![Знаменатель](https://github.com/Aksiniya/schedule/blob/master/images/%D0%B7%D0%BD%D0%B0%D0%BC%D0%B5%D0%BD%D0%B0%D1%82%D0%B5%D0%BB%D1%8C.png)

### Добавление предмета:

* Создавайте предметы с Вашими параметрами.
  * Устанавливайте название предмета, время начала и окончания, а также добавляйте описание.

![Создание нового предмета](https://github.com/Aksiniya/schedule/blob/master/images/%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5%20%D0%BD%D0%BE%D0%B2%D0%BE%D0%B3%D0%BE%20%D0%BF%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%B0.png)

### Обновление 1.1.0 (20.01.18)

* Добавлена вкладка настройки:
  * Возможность загрузки расписания для некторых групп ИУ8.
  * Возможность удаления всего расписания одной кнопкой.
![Настройки](https://github.com/Aksiniya/schedule/blob/master/images/%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B8.png)
* Кнопка очищения текста в поле при создании предмета или редактировании во вкладке описание.
* Исправлены ошибки:
  * Ошибка с удалением CheckMark после выхода из приложения.
  * Ошибка с масштабированием на некторых устройствах.

## Используемые компоненты

* Выбор даты для установки первого учебного дня в семестре: https://github.com/squimer/DatePickerDialog-iOS-Swift
* XML/HTML parser for Swift: https://github.com/tid-kijyun/Kanna
