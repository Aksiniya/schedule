import UIKit

// описание ячейки таблицы с расписанием
class SubjectTableCell: UITableViewCell {
    
    @IBOutlet weak var timeAtLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //вид выделенной ячейки
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = UITableViewCellSelectionStyle.None
    }
}