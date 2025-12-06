import UIKit

final class CourseTableViewCell: UITableViewCell {
    @IBOutlet var imageCourse: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    func configure(with course: Course) {
        //  Весь этот код выполняется в основном потоке (main thread)
        nameLabel.text = course.name
        languageLabel.text = course.language
        idLabel.text = course.id
        //  Нужно выйти в фоновый поток (global)
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png")!) else {return}
            //  Нужно вернуться в основной поток, для того, чтобы отобразить UI
            DispatchQueue.main.async() { [unowned self] in
                //  Компилятор остановится и будет ждать, пока не сработает строка снизу (получение картинки с интернета)
                //  После инициализации Data, содается изображение в imageData
                //  Затем, мы передаем это изображение в наш Outlet
                imageCourse.image = UIImage(data: imageData)
            }
        }
        
    }
}
