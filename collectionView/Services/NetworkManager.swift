import Foundation

enum NetworkError: Error {
    case InvalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void ) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return}
            //  Нужно вернуться в основной поток, для того, чтобы отобразить UI
            DispatchQueue.main.async() {
                completion(.success(imageData))
            }
        }
    }
}
