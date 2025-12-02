import UIKit

final class PhoneViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true //    Чтобы остановить анимацию загрузки, после ее скрытия
        fetchImage()
    }
    
    private func fetchImage() {
        // Data - содержатся данные, которые мы получаем после перехода по ссылке (фото)
        // Response - показывает различную информацию(по типу: откуда данные получены, метаданные)
        // Error - если есть data и response, то ошибки не будет
        
        // It will be not in the main thread at first
        URLSession.shared.dataTask(with: Link.phoneUrl.url) { [weak self] data, response, error in
            //  Делаем список захвата потому что, создаются две ссылки на этот VC и при закрытии одна ссылка оставалась бы в памяти
            guard let self else { return }
            // Вместо guard let data = data, let response = response... можно писать сокращенно
            guard let data, let response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            
            //  We need return to main thread, because main thread has a UI logic
            //  We also need return to main thread async (parallel to thread)
            DispatchQueue.main.async {
                //  Инциализируем изображение (достаём изображение из data)
                //  Self - обработали уже, поэтому можно применять (без него Xcode показывает ошибку)
                self.imageView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }.resume()
        //  Используем resume, потому что без вызова этого метода запрос(который выше) находится в подвешенном состоянии
    }
}
