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
    func fetch<T:Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data else {
                    print(error ?? "No error")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    //  После прохождения guard, в значении data хранится JSON-файл, который необходимо декодировать
                    let dataModel = try decoder.decode(T.self, from: data)
                    completion(.success(dataModel ))
                } catch {
                    completion(.failure(.decodingError))
                    //  Выведится не тот error, что выше(с сетью сязан), а другой (с декодипрованием связан)
                }

            }.resume()
    }
    func postRequest(with parameters: [String:Any], to url: URL, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        let serializedData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = serializedData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "No error")
                return
            }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                completion(.success(json))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
