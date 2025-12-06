import UIKit

final class PhoneViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true //    Чтобы остановить анимацию загрузки, после ее скрытия
        fetchImage()
    }
    
    private func fetchImage() {
        networkManager.fetchImage(from: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSci3e4K0DV-AzzuQdTfAqRL3ZXkjeQRnaWw&s")!) { [unowned self] result in
            switch result {
            case .success(let imageData):
                imageView.image = UIImage(data: imageData)
                activityIndicator.stopAnimating()
            case .failure(let error): break
                print(error)
            }
        }
    }
}
