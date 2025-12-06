import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping (Data) -> Void ) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {return}
            //  Нужно вернуться в основной поток, для того, чтобы отобразить UI
            DispatchQueue.main.async() {
                completion(imageData)
            }
        }
    }
}
