import UIKit

final class CourseTableViewCell: UITableViewCell {
    @IBOutlet var imageCourse: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with course: Course) {
        //  Весь этот код выполняется в основном потоке (main thread)
        nameLabel.text = course.name
        languageLabel.text = course.language
        idLabel.text = course.id
        //  Нужно выйти в фоновый поток (global)
        networkManager.fetchImage(from: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSci3e4K0DV-AzzuQdTfAqRL3ZXkjeQRnaWw&s")!) { [unowned self] imageData in
            imageCourse.image = UIImage(data: imageData)
            
        }
    }
}
