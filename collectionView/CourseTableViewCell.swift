import UIKit

final class CourseTableViewCell: UITableViewCell {
    @IBOutlet var imageCourse: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    func configure(with course: Course) {
        nameLabel.text = course.name
        languageLabel.text = course.language
        idLabel.text = course.id
        
    }
}
